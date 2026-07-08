#!/usr/bin/env bash
#
# Bootstrap a fresh Pop!_OS (or Ubuntu-based) machine with the tools this
# dotfiles repo (https://github.com/AukeMeijer/dotfiles) expects, then
# symlink every top-level config directory into ~/.config.
#
# Usage:
#   ./install-popos.sh
#
# Safe to re-run: every step checks whether its target is already installed
# / already linked before doing anything.

set -euo pipefail

# ---------------------------------------------------------------------------
# Setup
# ---------------------------------------------------------------------------

if [[ $EUID -eq 0 ]]; then
  echo "Run this as your normal user, not root (it uses sudo where needed)." >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_REPO="https://github.com/AukeMeijer/dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles-src"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

DPKG_ARCH="$(dpkg --print-architecture)"           # amd64 | arm64
UNAME_ARCH="$(uname -m)"                            # x86_64 | aarch64

c_blue="\033[1;34m"; c_green="\033[1;32m"; c_yellow="\033[1;33m"; c_reset="\033[0m"
log()  { echo -e "${c_blue}==>${c_reset} $*"; }
ok()   { echo -e "${c_green}  ok${c_reset} $*"; }
warn() { echo -e "${c_yellow}warn${c_reset} $*"; }
have() { command -v "$1" >/dev/null 2>&1; }

mkdir -p "$HOME/.local/bin"

gh_latest_tag() { # $1 = owner/repo
  curl -fsSL "https://api.github.com/repos/$1/releases/latest" \
    | grep -m1 '"tag_name"' | cut -d'"' -f4
}

# ---------------------------------------------------------------------------
# Base apt packages
# ---------------------------------------------------------------------------

log "Updating apt and installing base packages"
sudo apt update
sudo apt install -y \
  build-essential curl wget git unzip zip file gpg ca-certificates \
  zsh ripgrep fd-find bat htop mpv fontconfig fzf \
  ffmpegthumbnailer poppler-utils p7zip-full jq imagemagick unar
ok "base packages installed"

# Ubuntu/Pop ship bat/fd under different names — symlink to the names our
# configs (aliases.zsh, fzf.zsh, .zshenv) expect.
[[ -x /usr/bin/batcat && ! -e "$HOME/.local/bin/bat" ]] && ln -s /usr/bin/batcat "$HOME/.local/bin/bat"
[[ -x /usr/bin/fdfind && ! -e "$HOME/.local/bin/fd" ]] && ln -s /usr/bin/fdfind "$HOME/.local/bin/fd"
ok "bat / fd symlinked"

# ---------------------------------------------------------------------------
# eza (not in Ubuntu's default repos — add the official apt repo)
# ---------------------------------------------------------------------------

if ! have eza; then
  log "Installing eza"
  sudo mkdir -p /etc/apt/keyrings
  wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc \
    | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
  echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" \
    | sudo tee /etc/apt/sources.list.d/gierens.list >/dev/null
  sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
  sudo apt update
  sudo apt install -y eza
  ok "eza installed"
else
  ok "eza already installed"
fi

# ---------------------------------------------------------------------------
# GitHub CLI (gh) — official apt repo
# ---------------------------------------------------------------------------

if ! have gh; then
  log "Installing GitHub CLI"
  sudo mkdir -p -m 755 /etc/apt/keyrings
  wget -nv -O- https://cli.github.com/packages/githubcli-archive-keyring.gpg \
    | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null
  sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
  echo "deb [arch=$DPKG_ARCH signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
    | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
  sudo apt update
  sudo apt install -y gh
  ok "gh installed"
else
  ok "gh already installed"
fi

# ---------------------------------------------------------------------------
# zoxide + starship (official installer scripts)
# ---------------------------------------------------------------------------

if ! have zoxide; then
  log "Installing zoxide"
  curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
  ok "zoxide installed"
else
  ok "zoxide already installed"
fi

if ! have starship; then
  log "Installing starship"
  curl -sS https://starship.rs/install.sh | sh -s -- --yes
  ok "starship installed"
else
  ok "starship already installed"
fi

# ---------------------------------------------------------------------------
# Neovim — apt's version is too old for vim.pack (needs a recent build), so
# grab the latest official release tarball instead. Falls back to snap on
# unsupported architectures.
# ---------------------------------------------------------------------------

if ! have nvim || [[ "$(nvim --version | head -1 | grep -oE '[0-9]+\.[0-9]+' | head -1 | cut -d. -f2)" -lt 11 ]]; then
  log "Installing latest Neovim"
  NVIM_ASSET=""
  case "$UNAME_ARCH" in
    x86_64)  NVIM_ASSET="nvim-linux-x86_64.tar.gz" ;;
    aarch64) NVIM_ASSET="nvim-linux-arm64.tar.gz" ;;
  esac
  if [[ -n "$NVIM_ASSET" ]] && curl -fsSL -o "$TMP_DIR/nvim.tar.gz" \
      "https://github.com/neovim/neovim/releases/latest/download/$NVIM_ASSET"; then
    sudo rm -rf /opt/nvim
    sudo tar -C /opt -xzf "$TMP_DIR/nvim.tar.gz"
    sudo mv /opt/nvim-linux-* /opt/nvim
    sudo ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim
    ok "neovim installed to /opt/nvim"
  else
    warn "no prebuilt neovim tarball for $UNAME_ARCH, falling back to snap (classic)"
    sudo snap install nvim --classic
  fi
else
  ok "neovim already installed and recent enough"
fi

# ---------------------------------------------------------------------------
# lazygit
# ---------------------------------------------------------------------------

if ! have lazygit; then
  log "Installing lazygit"
  LG_TAG="$(gh_latest_tag jesseduffield/lazygit)"
  LG_VER="${LG_TAG#v}"
  case "$UNAME_ARCH" in
    x86_64)  LG_ARCH="Linux_x86_64" ;;
    aarch64) LG_ARCH="Linux_arm64" ;;
    *) LG_ARCH="" ;;
  esac
  if [[ -n "$LG_ARCH" ]]; then
    curl -fsSL -o "$TMP_DIR/lazygit.tar.gz" \
      "https://github.com/jesseduffield/lazygit/releases/download/${LG_TAG}/lazygit_${LG_VER}_${LG_ARCH}.tar.gz"
    tar -C "$TMP_DIR" -xzf "$TMP_DIR/lazygit.tar.gz" lazygit
    sudo install -m755 "$TMP_DIR/lazygit" /usr/local/bin/lazygit
    ok "lazygit installed"
  else
    warn "no lazygit release for $UNAME_ARCH, skipping"
  fi
else
  ok "lazygit already installed"
fi

# ---------------------------------------------------------------------------
# yazi
# ---------------------------------------------------------------------------

if ! have yazi; then
  log "Installing yazi"
  case "$UNAME_ARCH" in
    x86_64)  YAZI_TARGET="x86_64-unknown-linux-gnu" ;;
    aarch64) YAZI_TARGET="aarch64-unknown-linux-gnu" ;;
    *) YAZI_TARGET="" ;;
  esac
  if [[ -n "$YAZI_TARGET" ]]; then
    YAZI_TAG="$(gh_latest_tag sxyazi/yazi)"
    curl -fsSL -o "$TMP_DIR/yazi.zip" \
      "https://github.com/sxyazi/yazi/releases/download/${YAZI_TAG}/yazi-${YAZI_TARGET}.zip"
    unzip -q "$TMP_DIR/yazi.zip" -d "$TMP_DIR/yazi"
    sudo install -m755 "$TMP_DIR"/yazi/*/yazi /usr/local/bin/yazi
    sudo install -m755 "$TMP_DIR"/yazi/*/ya /usr/local/bin/ya
    ok "yazi installed"
  else
    warn "no yazi release for $UNAME_ARCH, skipping"
  fi
else
  ok "yazi already installed"
fi

# ---------------------------------------------------------------------------
# lf (used by the lf() navigation function in aliases.zsh)
# ---------------------------------------------------------------------------

if ! have lf; then
  log "Installing lf"
  case "$DPKG_ARCH" in
    amd64) LF_ARCH="amd64" ;;
    arm64) LF_ARCH="arm64" ;;
    *) LF_ARCH="" ;;
  esac
  if [[ -n "$LF_ARCH" ]]; then
    LF_TAG="$(gh_latest_tag gokcehan/lf)"
    curl -fsSL -o "$TMP_DIR/lf.tar.gz" \
      "https://github.com/gokcehan/lf/releases/download/${LF_TAG}/lf-linux-${LF_ARCH}.tar.gz"
    tar -C "$TMP_DIR" -xzf "$TMP_DIR/lf.tar.gz" lf
    sudo install -m755 "$TMP_DIR/lf" /usr/local/bin/lf
    ok "lf installed"
  else
    warn "no lf release for $DPKG_ARCH, skipping"
  fi
else
  ok "lf already installed"
fi

# ---------------------------------------------------------------------------
# Ghostty — no official apt package; install via Flathub
# ---------------------------------------------------------------------------

if ! have flatpak; then
  log "Installing flatpak"
  sudo apt install -y flatpak
fi
if ! flatpak remote-list | grep -q flathub; then
  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi
if ! flatpak list | grep -q com.mitchellh.ghostty; then
  log "Installing Ghostty (flatpak)"
  flatpak install -y flathub com.mitchellh.ghostty
  ok "ghostty installed — launch via 'flatpak run com.mitchellh.ghostty' or the app menu"
else
  ok "ghostty already installed"
fi

# ---------------------------------------------------------------------------
# Nerd Font (ghostty/config requests "MesloLGS Nerd Font Mono")
# ---------------------------------------------------------------------------

FONT_DIR="$HOME/.local/share/fonts/MesloNerdFont"
if [[ ! -d "$FONT_DIR" ]]; then
  log "Installing Meslo Nerd Font"
  mkdir -p "$FONT_DIR"
  NF_TAG="$(gh_latest_tag ryanoasis/nerd-fonts)"
  curl -fsSL -o "$TMP_DIR/Meslo.zip" \
    "https://github.com/ryanoasis/nerd-fonts/releases/download/${NF_TAG}/Meslo.zip"
  unzip -q "$TMP_DIR/Meslo.zip" -d "$FONT_DIR"
  fc-cache -f "$FONT_DIR" >/dev/null
  ok "Meslo Nerd Font installed"
else
  ok "Meslo Nerd Font already installed"
fi

# ---------------------------------------------------------------------------
# nvm + Node LTS (sourced by .zshrc)
# ---------------------------------------------------------------------------

export NVM_DIR="$HOME/.nvm"
if [[ ! -s "$NVM_DIR/nvm.sh" ]]; then
  log "Installing nvm"
  NVM_TAG="$(gh_latest_tag nvm-sh/nvm)"
  curl -fsSL "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_TAG}/install.sh" | bash
  ok "nvm installed"
else
  ok "nvm already installed"
fi
# shellcheck disable=SC1091
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh" && nvm install --lts

# ---------------------------------------------------------------------------
# Pull down this dotfiles repo and symlink each top-level dir into ~/.config
# ---------------------------------------------------------------------------

log "Fetching dotfiles repo"
if [[ ! -d "$DOTFILES_DIR/.git" ]]; then
  git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
else
  git -C "$DOTFILES_DIR" pull --ff-only
fi

mkdir -p "$HOME/.config"
for entry in "$DOTFILES_DIR"/*; do
  name="$(basename "$entry")"
  case "$name" in
    .git|.DS_Store|install-popos.sh|.claude) continue ;;
  esac
  target="$HOME/.config/$name"
  if [[ -e "$target" && ! -L "$target" ]]; then
    mv "$target" "${target}.bak.$(date +%s)"
    warn "backed up existing ~/.config/$name"
  fi
  ln -sfn "$entry" "$target"
  ok "linked ~/.config/$name"
done

# ---------------------------------------------------------------------------
# zsh: ZDOTDIR, default shell, required dirs
# ---------------------------------------------------------------------------

log "Configuring zsh ZDOTDIR"
ZSHENV_MARKER="# --- managed by dotfiles install-popos.sh ---"
if ! grep -qF "$ZSHENV_MARKER" /etc/zsh/zshenv 2>/dev/null; then
  sudo tee -a /etc/zsh/zshenv >/dev/null <<EOF

$ZSHENV_MARKER
if [[ -z "\$XDG_CONFIG_HOME" ]]; then
  export XDG_CONFIG_HOME="\$HOME/.config"
fi
if [[ -d "\$XDG_CONFIG_HOME/zsh" ]]; then
  export ZDOTDIR="\$XDG_CONFIG_HOME/zsh"
fi
EOF
  ok "/etc/zsh/zshenv updated"
else
  ok "/etc/zsh/zshenv already configured"
fi

mkdir -p "$HOME/.local/state/zsh" "$HOME/.cache/zsh"

if [[ "$SHELL" != "$(command -v zsh)" ]]; then
  log "Setting zsh as default shell"
  sudo chsh -s "$(command -v zsh)" "$USER"
  ok "default shell set to zsh (takes effect on next login)"
else
  ok "zsh already the default shell"
fi

# ---------------------------------------------------------------------------

echo
log "Done."
echo "Next steps:"
echo "  - Log out / back in (or reboot) to pick up the zsh shell + ZDOTDIR change"
echo "  - Launch Ghostty and set MesloLGS Nerd Font Mono as its font if not picked up automatically"
echo "  - Open nvim once to let it fetch plugins via vim.pack, then run :Mason to install LSP servers"
echo "  - Config source lives in $DOTFILES_DIR, symlinked into ~/.config"
