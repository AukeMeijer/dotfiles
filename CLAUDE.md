# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A personal dotfiles repo for macOS, Ubuntu Desktop, and Pop!_OS, built around a
consistent Gruvbox Dark theme across the terminal, editor, and shell. There is
no build/lint/test tooling — this is configuration, not an application. The
repo is cloned to `~/.dotfiles-src` and every top-level entry is symlinked
into `~/.config/<name>`; `~/.config/<dir>` is never a copy. If you are working
inside `~/.config`, you are editing symlinks — the actual files (and the git
history) live in `~/.dotfiles-src`, so `cd` there for any git operations.

## Install scripts

Three OS-specific, idempotent bootstrap scripts (`install-macos.sh`,
`install-ubuntu.sh`, `install-popos.sh`) each: install expected CLI/GUI tools,
clone this repo to `~/.dotfiles-src`, symlink every top-level entry into
`~/.config/`, and set up zsh as the login shell. `install-ubuntu.sh` (target:
26.04 LTS) and `install-popos.sh` (Pop!_OS or older/non-LTS Ubuntu) are *not*
interchangeable — Ubuntu 26.04's universe repo has current-enough eza, gh,
zoxide, starship, lazygit, lf, and ghostty to install via apt directly; the
Pop!_OS script still builds those from third-party repos / release tarballs /
flatpak. Both still install Neovim from the upstream release tarball since
apt's version doesn't reliably clear the `vim.pack`-required >=0.12 floor.

**The symlink loop in each install script is also the authoritative list of
what gets linked**: it walks every top-level entry in the cloned repo and
links it into `~/.config/`, skipping only `.git`, `.DS_Store`, the three
install scripts themselves, and `.claude`. This means adding a new top-level
file or directory here is enough — no separate registration step. Existing
non-symlink files at the target path are backed up (`.bak.<timestamp>`), not
overwritten.

## Making changes

- Treat each tool's config as independent — there's no shared build step, so
  changes to one directory (e.g. `nvim/`) don't affect others except where a
  file is explicitly a derived copy (see below).
- **`nvim/init.lua` is the source of truth for editor keybindings/theme;
  `vscode/` is a manually resynced derivative.** When changing Neovim
  keybindings, LSP servers, or theme, check whether `vscode/CLAUDE.md`'s
  parity tables need a matching update.
- Font is MesloLGS Nerd Font Mono at size 16 everywhere (Ghostty, Neovim, VS
  Code) — keep new terminal/editor configs consistent with this.
- Several directories have their own deeper `CLAUDE.md` (`zsh/`, `nvim/`,
  `vscode/`, `ghostty/`) — read the relevant one before editing that tool's
  config. `zsh/` additionally has its own `README.md` and `KEYBINDINGS.md`.
- `zsh/plugins/` is git-ignored; plugins are cloned there on first shell
  launch by `zsh/plugins.zsh`, not vendored in the repo.
- `bat`, `cagent`, `composer`, `envman`, `gh`, `git`, `github-copilot`,
  `htop`, `lazygit`, `lf`, `yazi` are small, single-purpose config
  directories with no deeper docs — the file(s) inside are self-explanatory.

## Verifying changes

There's no test suite. Verification is manual and tool-specific:
- Ghostty: reload with the configured keybind (`ctrl+b` then `r`) or `ghostty
  +list-themes` / `+list-keybinds` / `+list-fonts` to check option names.
- zsh: open a new shell, or `zplugin-update` to pull all plugins.
- Neovim: `:Nvim packupdate` to update plugins; reopen a file to pick up
  `init.lua` changes.
- Install scripts: safe to re-run — every step checks whether its target is
  already installed/linked before acting, so re-running after an edit is a
  reasonable way to sanity-check a script change.
