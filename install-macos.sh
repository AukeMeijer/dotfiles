#!/usr/bin/env bash
#
# Bootstrap a fresh macOS machine with the tools this dotfiles repo
# (https://github.com/AukeMeijer/dotfiles) expects, then symlink every
# top-level config directory into ~/.config.
#
# Usage:
#   ./install-macos.sh
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

DOTFILES_REPO="https://github.com/AukeMeijer/dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles-src"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

c_blue="\033[1;34m"; c_green="\033[1;32m"; c_yellow="\033[1;33m"; c_reset="\033[0m"
log()  { echo -e "${c_blue}==>${c_reset} $*"; }
ok()   { echo -e "${c_green}  ok${c_reset} $*"; }
warn() { echo -e "${c_yellow}warn${c_reset} $*"; }
have() { command -v "$1" >/dev/null 2>&1; }

gh_latest_tag() { # $1 = owner/repo
  curl -fsSL "https://api.github.com/repos/$1/releases/latest" \
    | grep -m1 '"tag_name"' | cut -d'"' -f4
}

# ---------------------------------------------------------------------------
# Homebrew
# ---------------------------------------------------------------------------

if ! have brew; then
  log "Installing Homebrew (this will also prompt for Xcode Command Line Tools if missing)"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [[ "$(uname -m)" == "arm64" ]]; then
  BREW_BIN="/opt/homebrew/bin/brew"
else
  BREW_BIN="/usr/local/bin/brew"
fi
eval "$("$BREW_BIN" shellenv)"
ok "homebrew ready ($(brew --prefix))"

log "Updating Homebrew"
brew update

# ---------------------------------------------------------------------------
# Core CLI tools
# ---------------------------------------------------------------------------

log "Installing CLI tools"
brew install \
  zsh neovim eza bat fd fzf zoxide starship ripgrep \
  yazi lazygit lf gh htop mpv git \
  ffmpegthumbnailer poppler sevenzip jq imagemagick unar
ok "CLI tools installed"

# ---------------------------------------------------------------------------
# GUI apps + fonts
# ---------------------------------------------------------------------------

log "Installing Ghostty"
brew install --cask ghostty

log "Installing Visual Studio Code"
brew install --cask visual-studio-code

log "Installing Meslo Nerd Font"
brew install --cask font-meslo-lg-nerd-font \
  || { brew tap homebrew/cask-fonts; brew install --cask font-meslo-lg-nerd-font; }

# ---------------------------------------------------------------------------
# Use Homebrew's zsh as the login shell (newer than Apple's bundled zsh)
# ---------------------------------------------------------------------------

BREW_ZSH="$(brew --prefix)/bin/zsh"
if ! grep -qF "$BREW_ZSH" /etc/shells 2>/dev/null; then
  log "Registering Homebrew zsh in /etc/shells"
  echo "$BREW_ZSH" | sudo tee -a /etc/shells >/dev/null
fi
if [[ "$SHELL" != "$BREW_ZSH" ]]; then
  log "Setting Homebrew zsh as default shell"
  chsh -s "$BREW_ZSH"
  ok "default shell set to $BREW_ZSH (takes effect on next login)"
else
  ok "Homebrew zsh already the default shell"
fi

# ---------------------------------------------------------------------------
# nvm + Node LTS (sourced by .zshrc — installed via the official script so
# it lands at ~/.nvm, matching what .zshrc expects; brew's nvm formula uses
# a different layout)
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
    .git|.DS_Store|install-popos.sh|install-macos.sh|.claude) continue ;;
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
# VS Code: symlink settings/keybindings from ~/.config/vscode (the dotfiles
# copy, just linked above) into the location VS Code actually reads on
# macOS, then install the extensions that config expects.
# ---------------------------------------------------------------------------

log "Linking VS Code settings"
VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
mkdir -p "$VSCODE_USER_DIR"
for f in settings.json keybindings.json; do
  target="$VSCODE_USER_DIR/$f"
  if [[ -e "$target" && ! -L "$target" ]]; then
    mv "$target" "${target}.bak.$(date +%s)"
    warn "backed up existing $target"
  fi
  ln -sfn "$HOME/.config/vscode/$f" "$target"
  ok "linked $target"
done

if have code; then
  CODE_BIN="code"
elif [[ -x "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" ]]; then
  CODE_BIN="/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
else
  CODE_BIN=""
fi

if [[ -n "$CODE_BIN" ]]; then
  log "Installing VS Code extensions"
  for ext in \
    vscodevim.vim jdinhlife.gruvbox llvm-vs-code-extensions.vscode-clangd \
    eamodio.gitlens esbenp.prettier-vscode dbaeumer.vscode-eslint \
    ms-python.python ms-python.vscode-pylance \
    vscode-icons-team.vscode-icons streetsidesoftware.code-spell-checker; do
    if "$CODE_BIN" --install-extension "$ext" --force >/dev/null; then
      ok "extension: $ext"
    else
      warn "failed to install extension: $ext"
    fi
  done
else
  warn "VS Code CLI not found, skipping extension install"
fi

# ---------------------------------------------------------------------------
# zsh: ZDOTDIR + required dirs
# (on macOS the system-wide env file is /etc/zshenv, not /etc/zsh/zshenv)
# ---------------------------------------------------------------------------

log "Configuring zsh ZDOTDIR"
ZSHENV_MARKER="# --- managed by dotfiles install-macos.sh ---"
if ! grep -qF "$ZSHENV_MARKER" /etc/zshenv 2>/dev/null; then
  sudo tee -a /etc/zshenv >/dev/null <<EOF

$ZSHENV_MARKER
if [[ -z "\$XDG_CONFIG_HOME" ]]; then
  export XDG_CONFIG_HOME="\$HOME/.config"
fi
if [[ -d "\$XDG_CONFIG_HOME/zsh" ]]; then
  export ZDOTDIR="\$XDG_CONFIG_HOME/zsh"
fi
EOF
  ok "/etc/zshenv updated"
else
  ok "/etc/zshenv already configured"
fi

mkdir -p "$HOME/.local/state/zsh" "$HOME/.cache/zsh" "$HOME/.local/bin"

# ---------------------------------------------------------------------------

echo
log "Done."
echo "Next steps:"
echo "  - Log out / back in (or open a new terminal) to pick up the shell + ZDOTDIR change"
echo "  - Launch Ghostty and confirm MesloLGS Nerd Font Mono is selected as its font"
echo "  - Open nvim once to let it fetch plugins via vim.pack, then run :Mason to install LSP servers"
echo "  - Open VS Code and reload the window so the Gruvbox theme takes effect"
echo "  - Config source lives in $DOTFILES_DIR, symlinked into ~/.config"
