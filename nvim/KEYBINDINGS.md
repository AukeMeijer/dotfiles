# Neovim Keybindings

Leader key: `<Space>`

## Navigation

| Key | Mode | Action |
|-----|------|--------|
| `j` | n | Down (wrap-aware) |
| `k` | n | Up (wrap-aware) |
| `<C-d>` | n | Half page down (centered) |
| `<C-u>` | n | Half page up (centered) |
| `<C-h>` | n | Move to left window |
| `<C-j>` | n | Move to bottom window |
| `<C-k>` | n | Move to top window |
| `<C-l>` | n | Move to right window |

## Search

| Key | Mode | Action |
|-----|------|--------|
| `n` | n | Next search result (centered) |
| `N` | n | Previous search result (centered) |
| `<leader>c` | n | Clear search highlights |

## Editing

| Key | Mode | Action |
|-----|------|--------|
| `J` | n | Join lines (keep cursor position) |
| `<leader>p` | v | Paste without yanking replaced text |
| `<leader>x` | n/v | Delete without yanking |
| `<A-j>` | n | Move line down |
| `<A-k>` | n | Move line up |
| `<A-j>` | v | Move selection down |
| `<A-k>` | v | Move selection up |
| `<` | v | Indent left and reselect |
| `>` | v | Indent right and reselect |

## Windows & Splits

| Key | Mode | Action |
|-----|------|--------|
| `<leader>sv` | n | Split vertically |
| `<leader>sh` | n | Split horizontally |
| `<C-Up>` | n | Increase window height |
| `<C-Down>` | n | Decrease window height |
| `<C-Left>` | n | Decrease window width |
| `<C-Right>` | n | Increase window width |

## Buffers

| Key | Mode | Action |
|-----|------|--------|
| `<leader>bn` | n | Next buffer |
| `<leader>bp` | n | Previous buffer |

## File

| Key | Mode | Action |
|-----|------|--------|
| `<leader>e` | n | Toggle file tree (nvim-tree) |
| `<leader>pa` | n | Copy full file path to clipboard |

## FZF

| Key | Mode | Action |
|-----|------|--------|
| `<leader>ff` | n | Find files |
| `<leader>fg` | n | Live grep |
| `<leader>fb` | n | Buffers |
| `<leader>fh` | n | Help tags |
| `<leader>fx` | n | Document diagnostics |
| `<leader>fX` | n | Workspace diagnostics |

## LSP (active when a language server is attached)

| Key | Mode | Action |
|-----|------|--------|
| `K` | n | Hover documentation |
| `<leader>gd` | n | Go to definition (fzf, jump if single result) |
| `<leader>gD` | n | Go to definition (direct) |
| `<leader>gS` | n | Go to definition in vertical split |
| `<leader>ca` | n | Code action |
| `<leader>rn` | n | Rename symbol |
| `<leader>oi` | n | Organize imports |
| `<leader>fr` | n | Find references |
| `<leader>ft` | n | Find type definitions |
| `<leader>fs` | n | Document symbols |
| `<leader>fw` | n | Workspace symbols |
| `<leader>fi` | n | Find implementations |

## Diagnostics

| Key | Mode | Action |
|-----|------|--------|
| `<leader>d` | n | Float diagnostic at cursor |
| `<leader>D` | n | Float diagnostic for current line |
| `<leader>dl` | n | Float diagnostic (default scope) |
| `<leader>nd` | n | Jump to next diagnostic |
| `<leader>pd` | n | Jump to previous diagnostic |
| `<leader>q` | n | Open diagnostic list (loclist) |
| `<leader>td` | n | Toggle diagnostics on/off |

## Git (mini.diff + mini.git)

| Key | Mode | Action |
|-----|------|--------|
| `]h` | n | Next git hunk |
| `[h` | n | Previous git hunk |
| `<leader>hs` | n | Stage hunk |
| `<leader>hp` | n | Toggle diff overlay |
| `<leader>hb` | n | Git blame / show at cursor |

## Obsidian Notes

| Key | Mode | Action |
|-----|------|--------|
| `<leader>nn` | n | New note |
| `<leader>nf` | n | Find note (quick switch) |
| `<leader>ns` | n | Search notes |
| `<leader>nt` | n | Open today's daily note |
| `<leader>nw` | n | Switch workspace |

## Terminal

| Key | Mode | Action |
|-----|------|--------|
| `<leader>t` | n | Toggle floating terminal |
| `<Esc>` | t | Exit to normal mode |
| `<C-q>` | t | Close floating terminal |

## Completion (blink.cmp)

| Key | Mode | Action |
|-----|------|--------|
| `<C-Space>` | i | Show / hide completion menu |
| `<CR>` | i | Accept completion |
| `<C-j>` | i | Select next item |
| `<C-k>` | i | Select previous item |
| `<Tab>` | i | Expand / jump forward in snippet |
| `<S-Tab>` | i | Jump backward in snippet |
