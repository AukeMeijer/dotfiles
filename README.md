# dotfiles

Personal `~/.config` for macOS and Pop!_OS (Ubuntu-based). Everything here is
symlinked in from a single clone, all built around a consistent Gruvbox Dark
theme across the terminal, editor, and shell.

## Install

```sh
# macOS
curl -fsSL https://raw.githubusercontent.com/AukeMeijer/dotfiles/main/install-macos.sh | bash

# Pop!_OS / Ubuntu
curl -fsSL https://raw.githubusercontent.com/AukeMeijer/dotfiles/main/install-popos.sh | bash
```

Each script:

1. Installs the CLI tools and GUI apps these configs expect (via Homebrew or
   apt, plus a couple of vendor install scripts for tools not in the default
   repos).
2. Clones this repo to `~/.dotfiles-src`.
3. Symlinks every top-level directory into `~/.config/`.
4. Sets `ZDOTDIR` and installs zsh as the default login shell.

Both scripts are idempotent — safe to re-run any time to pick up updates or
finish a partial install.

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
| [`homebrew/`](homebrew), [`github-copilot/`](github-copilot), [`cagent/`](cagent), [`composer/`](composer) | Misc | App-managed state, kept here mostly to track/back up |

Several directories have their own `CLAUDE.md` with deeper notes for whoever
(human or Claude Code) is editing that tool's config, and `zsh/` has a
dedicated `README.md` and `KEYBINDINGS.md`.

## Structure conventions

- Config source of truth lives in this repo; `~/.config/<dir>` is always a
  symlink back to it, never a copy.
- `nvim/init.lua` is the source of truth for editor keybindings/theme;
  `vscode/` is resynced from it, not the other way around.
- Font is MesloLGS Nerd Font Mono at size 16 everywhere (Ghostty, Neovim, VS
  Code) for visual consistency across a screen-shared session.
