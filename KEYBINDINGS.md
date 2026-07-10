# Keybinds

All custom keybindings across this dotfiles configuration, by tool. Tools not
listed (`gh`, `bat`, `htop`, `lf`, `yazi`, `lazygit`, etc.) use their
application defaults — nothing in this repo overrides their keybinds.

Full per-tool detail lives in:
- [`nvim/KEYBINDINGS.md`](nvim/KEYBINDINGS.md)
- [`zsh/KEYBINDINGS.md`](zsh/KEYBINDINGS.md)
- [`ghostty/CLAUDE.md`](ghostty/CLAUDE.md)
- [`vscode/CLAUDE.md`](vscode/CLAUDE.md)

---

## Ghostty (terminal)

Leader: `Ctrl+B` (tmux-style, pressed then released before the next key).

| Key | Action |
|-----|--------|
| `Ctrl+B > r` | Reload config |
| `Ctrl+B > x` | Close surface |
| `Ctrl+B > f` | Toggle fullscreen |
| `Ctrl+B > n` | New window |
| `Ctrl+B > c` | New tab |
| `Ctrl+B > Shift+L` | Next tab |
| `Ctrl+B > Shift+H` | Previous tab |
| `Ctrl+B > ,` | Move tab left |
| `Ctrl+B > .` | Move tab right |
| `Ctrl+B > 1`–`9` | Go to tab N |
| `Ctrl+B > \` | Split right |
| `Ctrl+B > -` | Split down |
| `Ctrl+B > h/j/k/l` | Go to split (left/bottom/top/right) |
| `Ctrl+B > z` | Toggle split zoom |
| `Ctrl+B > e` | Equalize splits |
| `Shift+Enter` | Insert literal newline (`\x1b\r`) |

---

## Zsh

| Key | Action |
|-----|--------|
| `Ctrl+→` | Move forward one word |
| `Ctrl+←` | Move backward one word |
| `↑` / `↓` | History search by substring prefix |
| `Ctrl+R` | Fuzzy history search (fzf) |
| `Ctrl+T` | Fuzzy file search, includes hidden files (fzf) |
| `Ctrl+F` | Fuzzy file search, excludes hidden files (fzf) |
| `Ctrl+\` | Toggle autosuggestions on/off |

---

## Neovim

Leader: `Space`. Modes: `n` normal, `v` visual, `i` insert, `t` terminal.

### Navigation
| Key | Mode | Action |
|-----|------|--------|
| `j` / `k` | n | Down / up (wrap-aware) |
| `Ctrl+d` / `Ctrl+u` | n | Half page down / up (centered) |
| `Ctrl+h/j/k/l` | n | Move to left/bottom/top/right window |

### Search
| Key | Mode | Action |
|-----|------|--------|
| `n` / `N` | n | Next / previous search result (centered) |
| `<leader>c` | n | Clear search highlights |

### Editing
| Key | Mode | Action |
|-----|------|--------|
| `J` | n | Join lines (keep cursor position) |
| `<leader>p` | v | Paste without yanking replaced text |
| `<leader>x` | n/v | Delete without yanking |
| `Alt+j` / `Alt+k` | n/v | Move line/selection down / up |
| `<` / `>` | v | Indent left/right and reselect |

### Windows, splits & buffers
| Key | Mode | Action |
|-----|------|--------|
| `<leader>sv` / `<leader>sh` | n | Split vertically / horizontally |
| `Ctrl+Up/Down/Left/Right` | n | Resize window (height/height/width/width) |
| `<leader>bn` / `<leader>bp` | n | Next / previous buffer |

### Files & fuzzy finding (fzf-lua)
| Key | Mode | Action |
|-----|------|--------|
| `<leader>e` | n | Toggle file tree (nvim-tree) |
| `<leader>pa` | n | Copy full file path to clipboard |
| `<leader>ff` | n | Find files |
| `<leader>fg` | n | Live grep |
| `<leader>fb` | n | Buffers |
| `<leader>fh` | n | Help tags |
| `<leader>fx` / `<leader>fX` | n | Document / workspace diagnostics |

### LSP
| Key | Mode | Action |
|-----|------|--------|
| `K` | n | Hover documentation |
| `<leader>gd` | n | Go to definition (fzf, jumps if single result) |
| `<leader>gD` | n | Go to definition (direct) |
| `<leader>gS` | n | Go to definition in vertical split |
| `<leader>ca` | n | Code action |
| `<leader>rn` | n | Rename symbol |
| `<leader>oi` | n | Organize imports |
| `<leader>fr` | n | Find references |
| `<leader>ft` | n | Find type definitions |
| `<leader>fs` / `<leader>fw` | n | Document / workspace symbols |
| `<leader>fi` | n | Find implementations |

### Diagnostics
| Key | Mode | Action |
|-----|------|--------|
| `<leader>d` / `<leader>D` | n | Float diagnostic at cursor / current line |
| `<leader>dl` | n | Float diagnostic (default scope) |
| `<leader>nd` / `<leader>pd` | n | Next / previous diagnostic |
| `<leader>q` | n | Open diagnostic list (loclist) |
| `<leader>td` | n | Toggle diagnostics on/off |

### Debugging (nvim-dap, C/C++)
| Key | Mode | Action |
|-----|------|--------|
| `F5` | n | Continue / start debugging |
| `F9` | n | Toggle breakpoint |
| `F10` / `F11` / `F12` | n | Step over / into / out |
| `<leader>kb` | n | Set conditional breakpoint |
| `<leader>kr` | n | Toggle REPL |
| `<leader>ku` | n | Toggle debug UI |
| `<leader>kx` | n | Terminate debug session |
| `<leader>kl` | n | Run last debug configuration |

### Git (mini.diff / mini.git)
| Key | Mode | Action |
|-----|------|--------|
| `]h` / `[h` | n | Next / previous git hunk |
| `<leader>hs` | n | Stage hunk |
| `<leader>hp` | n | Toggle diff overlay |
| `<leader>hb` | n | Git blame / show at cursor |

### Obsidian notes
| Key | Mode | Action |
|-----|------|--------|
| `<leader>nn` | n | New note |
| `<leader>nf` | n | Find note (quick switch) |
| `<leader>ns` | n | Search notes |
| `<leader>nt` | n | Open today's daily note |
| `<leader>nw` | n | Switch workspace |

### Terminal
| Key | Mode | Action |
|-----|------|--------|
| `<leader>t` | n | Toggle floating terminal |
| `Esc` | t | Exit to normal mode |
| `Ctrl+q` | t | Close floating terminal |

### Completion (blink.cmp)
| Key | Mode | Action |
|-----|------|--------|
| `Ctrl+Space` | i | Show / hide completion menu |
| `Enter` | i | Accept completion |
| `Ctrl+j` / `Ctrl+k` | i | Select next / previous item |
| `Tab` / `Shift+Tab` | i | Expand / jump forward / backward in snippet |

---

## VS Code

Mirrors the Neovim keybindings above via the Vim extension (`<leader>` chords
in `settings.json`) plus plain Ctrl/Alt/Cmd chords in `keybindings.json`. Where
identical to Neovim, only VS Code-specific differences are called out.

| Key | Action |
|-----|--------|
| `<leader>c/x/p/bn/bp/e/pa/sv/sh/tt` | Same as Neovim (see above) |
| `<leader>ff/fg/fb/fh/fx/fX` | fzf-lua equivalents → Quick Open / Find in Files / open editors / command palette / Problems panel |
| `K`, `<leader>gd/gD/gS/ca/rn/oi/fr/ft/fs/fw/fi` | Same as Neovim (LSP) |
| `<leader>d/D/nd/pd/q` | Same as Neovim (diagnostics); `<leader>td` has no VS Code equivalent (unmapped) |
| `]h` / `[h` | Next / previous changed hunk |
| `<leader>hs` | Stage hunk / selected range (normal + visual) |
| `<leader>hp` | Open inline change preview |
| `<leader>hb` | Toggle line blame (requires GitLens) |
| `Ctrl+h/j/k/l` | Focus editor group left/below/above/right (or terminal pane when terminal focused) |
| `Alt+j` / `Alt+k` | Move line/selection down / up (normal + visual) |
| `Alt+h` / `Alt+l` | Outdent / indent line or selection (normal + visual) |
| `Alt+Down` / `Alt+Up` | Move line down / up (fallback when Vim extension is off) |
| `Ctrl+Up/Down/Left/Right` | Resize view (height/height/width/width) |
| `Ctrl+Space` / `Enter` / `Ctrl+j` / `Ctrl+k` | Completion menu show / accept / next / previous |
| `Tab` / `Shift+Tab` | Snippet forward / backward |
| `Ctrl+q` | Close terminal (while terminal focused) |
| `Esc` | Exit to Normal mode in terminal (limited support) |
| `Ctrl+n` / `Ctrl+p` | Next / previous item in Quick Open |

### VS Code-only additions (no Neovim equivalent)
| Key | Action |
|-----|--------|
| `Ctrl+s` | Save file |
| `Alt+a` | Select all |
| `Cmd+\` | Split editor right |
| `Cmd+-` | Split editor down |
| `Ctrl+\` | Toggle terminal (alternate to `<leader>tt`) |
| `j` then `k` (insert mode) | Exit to Normal mode |

### Disabled Vim-extension Ctrl keys
Passed through to VS Code instead of the Vim extension: `Ctrl+A` (select all),
`Ctrl+C` (copy), `Ctrl+V` (paste), `Ctrl+X` (cut), `Ctrl+F` (find), `Ctrl+Z`
(undo), `Ctrl+Y`/`Ctrl+N`/`Ctrl+P`/`Ctrl+E` (completion/quick-open
navigation).

---

## Lazygit

`lazygit/config.yml` only configures theme colors — no keybindings are
overridden, so all of lazygit's default keybinds apply (see `?` inside
lazygit for the built-in cheat sheet).
