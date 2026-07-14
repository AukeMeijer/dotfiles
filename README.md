# dotfiles

Personal `~/.config` for macOS, Ubuntu Desktop, and Pop!_OS. Everything here
is symlinked in from a single clone, all built around a consistent Gruvbox
Dark theme across the terminal, editor, and shell.

## Install

```sh
# macOS
curl -fsSL https://raw.githubusercontent.com/AukeMeijer/dotfiles/main/install-macos.sh | bash

# Ubuntu Desktop 26.04 LTS
curl -fsSL https://raw.githubusercontent.com/AukeMeijer/dotfiles/main/install-ubuntu.sh | bash

# Pop!_OS (or older/non-LTS Ubuntu)
curl -fsSL https://raw.githubusercontent.com/AukeMeijer/dotfiles/main/install-popos.sh | bash
```

Each script:

1. Installs the CLI tools and GUI apps these configs expect (via Homebrew or
   apt, plus a couple of vendor install scripts for tools not in the default
   repos).
2. Clones this repo to `~/.dotfiles-src`.
3. Symlinks every top-level directory into `~/.config/`.
4. Sets `ZDOTDIR` and installs zsh as the default login shell.

`install-ubuntu.sh` and `install-popos.sh` aren't interchangeable: Ubuntu
26.04's universe repo carries current-enough versions of eza, gh, zoxide,
starship, lazygit, lf, and ghostty, so `install-ubuntu.sh` installs all of
those straight from apt. Pop!_OS tracks an older/different base without those
backported, so `install-popos.sh` still builds them from third-party repos /
GitHub release tarballs / flatpak — use it for Pop!_OS or any older/non-LTS
Ubuntu. Both scripts install Neovim from the latest upstream release tarball
regardless, since apt's version (on either distro) doesn't reliably clear the
`vim.pack`-required >=0.12 floor.

All three scripts are idempotent — safe to re-run any time to pick up
updates or finish a partial install.

## Layout

| Directory | Tool | Notes |
|---|---|---|
| [`zsh/`](zsh) | Shell | Modular config, no plugin manager (see [`zsh/CLAUDE.md`](zsh/CLAUDE.md)) |
| [`nvim/`](nvim) | Neovim | Single-file `init.lua`, plugins via `vim.pack` |
| [`ghostty/`](ghostty) | Terminal | Gruvbox Dark Hard theme |
| [`vscode/`](vscode) | VS Code | Mirrors the Neovim keybindings/theme |
| [`git/`](git) | Git | Global `ignore` |
| [`gh/`](gh) | GitHub CLI | |
| [`lazygit/`](lazygit) | lazygit | |
| [`yazi/`](yazi) | yazi (file manager) | Theme only |
| [`lf/`](lf) | lf (file manager) | Icons |
| [`bat/`](bat) | bat | Theme |
| [`htop/`](htop) | htop | |
| [`envman`](envman) | envman | `PATH`/`ENV`/alias/function files sourced by the shell |
| [`github-copilot/`](github-copilot), [`cagent/`](cagent), [`composer/`](composer) | Misc | App-managed state, kept here mostly to track/back up |

The top-level [`CLAUDE.md`](CLAUDE.md) covers repo-wide conventions for
Claude Code; several directories additionally have their own `CLAUDE.md` with
deeper notes for whoever (human or Claude Code) is editing that tool's
config, and `zsh/` has a dedicated `README.md` and `KEYBINDINGS.md`. The
top-level [`KEYBINDINGS.md`](KEYBINDINGS.md) rolls up every custom keybind
across tools, with links out to each tool's own detail doc.

## Structure conventions

- Config source of truth lives in this repo; `~/.config/<dir>` is always a
  symlink back to it, never a copy.
- `nvim/init.lua` is the source of truth for editor keybindings/theme;
  `vscode/` is resynced from it, not the other way around.
- Font is MesloLGS Nerd Font Mono at size 16 everywhere (Ghostty, Neovim, VS
  Code) for visual consistency across a screen-shared session.

## Making changes / pushing to GitHub

Edit files under `~/.dotfiles-src` — **not** `~/.config`. The install scripts
clone the repo to `~/.dotfiles-src` and symlink each top-level entry into
`~/.config/<name>`, so `~/.config/<dir>` is a symlink back to the clone, not
a separate copy; editing through the `~/.config` path edits the same files,
but it has no `.git` of its own, so all git operations (`add`, `commit`,
`push`, `pull`) must be run from `~/.dotfiles-src`:

```sh
cd ~/.dotfiles-src
git add -A
git commit -m "..."
git push
```
