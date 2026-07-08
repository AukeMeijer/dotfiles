# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a configuration directory for Ghostty terminal emulator. The main configuration file is `config`, which controls all aspects of the terminal's appearance, behavior, and keybindings.

## Configuration File Structure

The `config` file uses a simple `key = value` format. Lines starting with `#` are comments.

### Key Configuration Areas

1. **Font Settings** (lines 1-6)
   - `font-family`: The terminal font (MesloLGS Nerd Font Mono)
   - `font-fallback`: Fallback fonts for missing glyphs
   - `font-size`: Font size in points (16 - matches VS Code and Neovim)

2. **Visual Appearance** (lines 5, 24-26, 29)
   - `theme`: Color theme (`Gruvbox Dark Hard` - matches Neovim/VS Code/Yazi/Zsh/Starship)
   - `background`: Custom background color (`#282828` - Gruvbox Dark background)
   - `background-opacity`: Transparency level (0.0-1.0)
   - `background-blur`: Blur effect behind terminal (pixels)
   - `split-divider-color`: Split separator color (`#928374` - Gruvbox gray)
   - `window-colorspace`: Color profile (display-p3 for wide gamut)
   - `macos-titlebar-style`: macOS-specific titlebar appearance

3. **Shell Integration** (line 6)
   - Controls which shell features are enabled/disabled
   - Format: comma-separated features, use `no-` prefix to disable

4. **Keybindings** (lines 34-66)
   - Format: `keybind = <key-combination>=<action>[:<argument>]`
   - Leader key pattern: `ctrl+b>` means press Ctrl+B, then the next key (tmux-style)
   - Actions include: `new_window`, `new_tab`, `new_split`, `goto_split`, `reload_config`, etc.

## Common Commands

### Testing Configuration Changes
```bash
# Reload config using the configured keybind
# Ctrl+B, then R (as configured in line 35)
```

### Listing Available Options
```bash
# List all available themes
ghostty +list-themes

# List all keybindings
ghostty +list-keybinds

# List available fonts
ghostty +list-fonts

# Show version
ghostty +version
```

### Launching Ghostty (macOS)
```bash
# Launch from CLI (required on macOS instead of direct CLI execution)
open -na Ghostty.app

# Launch with config overrides
open -na Ghostty.app --args --font-size=14 --theme=dracula
```

## Keybinding Architecture

This configuration uses a **leader key pattern** (ctrl+b) following tmux conventions:

- **Leader**: `ctrl+b` - press this combination first, then the action key
- **Window management**: `n` (new window), `x` (close surface), `f` (fullscreen)
- **Tab management**: `c` (new tab), `shift+h/l` (navigate), `1-9` (goto tab), `,/.` (move tab)
- **Split management**: `\` (split right), `-` (split down), `h/j/k/l` (navigate), `z` (zoom toggle), `e` (equalize)
- **Config reload**: `r` (reload configuration)

**Why Ctrl+B?** This is the default leader key used by tmux, making it familiar to tmux users and avoiding conflicts with terminal applications that use Ctrl+A (like Emacs mode or nested screen sessions).

## Configuration Best Practices

1. **Backup files**: The `.bak` file shows configuration backups are kept - maintain this practice when making significant changes
2. **Testing changes**: Use `ctrl+b>r` (reload_config) to test changes without restarting
3. **Comments**: Keep commented alternatives (like lines 4-5 for font-family) for easy switching
4. **Color values**: Use hex format with `#` prefix (e.g., `#282828` for background)
5. **Opacity**: Separate `background-opacity` from the color value for better control
6. **Font fallbacks**: Multiple fallback fonts configured for missing glyphs and emoji support

## macOS-Specific Notes

- Launching from CLI requires `open -na Ghostty.app` wrapper
- The titlebar style is set to `transparent` for native macOS appearance
- Display P3 colorspace is enabled for wide color gamut support
- Window state is saved (`window-save-state = always`)
