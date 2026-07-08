# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A modular, dependency-managed zsh configuration targeting macOS (Homebrew), Arch Linux, and Ubuntu. No third-party plugin manager — plugins are cloned via a minimal built-in loader in `plugins.zsh`.

## File layout

| File | Purpose |
|------|---------|
| `.zshenv` | XDG dirs, `$EDITOR`, `$MANPAGER`, `$PATH`, `$STARSHIP_CONFIG` — loaded by every zsh process |
| `.zshrc` | History options, completion, fzf key-binding sources, and `source`s for the modular files below |
| `aliases.zsh` | Shell aliases and the `lf()` navigation function |
| `bindings.zsh` | Key bindings (registered inside `zvm_after_init` so zsh-vi-mode doesn't clobber them) |
| `fzf.zsh` | `FZF_*` env vars, preview command, and the `_fzf_file_no_hidden` widget |
| `plugins.zsh` | `_zplugin_load` (auto-clones on first launch) and `zplugin-update` (pull all plugins) |
| `prompt.zsh` | `starship init zsh` |

## Plugins

Cloned into `plugins/` (git-ignored) on first launch:

- `zdharma-continuum/fast-syntax-highlighting`
- `zsh-users/zsh-autosuggestions`
- `zsh-users/zsh-history-substring-search`
- `jeffreytse/zsh-vi-mode`

## Key conventions

- **Custom bindings must live inside `zvm_after_init()`** in `bindings.zsh` — zsh-vi-mode resets all ZLE bindings during its own init, so anything bound before that hook fires is silently discarded.
- **`$ZDOTDIR` is `~/.config/zsh`** — set in `/etc/zsh/zshenv` as part of setup, not in the repo itself.
- **`local.zsh`** is git-ignored and sourced nowhere by default; it's the intended place for machine-local overrides (add a `source "$ZDOTDIR/local.zsh"` to `.zshrc` if needed).
- History is stored at `$XDG_STATE_HOME/zsh/history`, completion cache at `$XDG_CACHE_HOME/zsh/zcompdump`.
- Ubuntu ships `bat` as `batcat` and `fd` as `fdfind` — `.zshenv` and the README handle both; keep cross-distro guards when adding new tool invocations.

## Plugin update command

```sh
zplugin-update
```
