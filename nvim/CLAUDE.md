# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture

This is a single-file Neovim config — everything lives in `init.lua`. There are no split modules or subdirectories. The file is organized into clearly marked sections with `-- ====` dividers:

1. **Transparency / Options / Keymaps / Autocmds** — vanilla Neovim setup
2. **Plugins** — declared via `vim.pack.add()` (Neovim 0.11+ built-in package manager)
3. **Plugin configs** — all inline, in the same file after the `vim.pack.add()` block

The lock file is `nvim-pack-lock.json` and is managed automatically by `vim.pack`.

## Plugin management

Plugins are added with `vim.pack.add()`. To update all plugins, run `:Nvim packupdate` inside Neovim. To pin a plugin to a specific version or branch, use the table form:

```lua
{ src = "https://github.com/...", branch = "main", version = vim.version.range("1.*") }
```

## LSP setup

LSP uses Neovim's native `vim.lsp.config()` / `vim.lsp.enable()` API (not the lspconfig wrapper pattern). Each server is configured with `vim.lsp.config("server_name", { ... })` and then enabled via `vim.lsp.enable({ "server_name", ... })`.

Servers in use: `lua_ls`, `pyright`, `bashls`, `ts_ls`, `gopls`, `clangd`, `efm`. Rust uses `rustaceanvim` (configured via `vim.g.rustaceanvim`) which manages rust-analyzer separately; its capabilities are wired to `blink.cmp` directly.

LSP servers are installed via Mason (`:Mason` inside Neovim).

## Formatting & linting

All formatting and linting goes through **efm-langserver** (`efm` LSP) using `efmls-configs-nvim` presets. Format on save is implemented in the `BufWritePre` autocmd and only fires when the `efm` client is attached to the buffer.

Formatters/linters per language:
- Lua: stylua + luacheck
- Python: black + flake8
- JS/TS/Vue/Svelte: prettier_d + eslint_d
- Go: gofumpt + go_revive
- C/C++: clang_format + cpplint
- Shell: shfmt + shellcheck
- JSON: fixjson + eslint_d

## Completion

`blink.cmp` handles completion with LuaSnip for snippet expansion. Completion is disabled for markdown buffers. Keymap preset is `none` — custom bindings: `<C-Space>` show/hide, `<CR>` accept, `<C-j>/<C-k>` navigate, `<Tab>/<S-Tab>` snippet forward/backward.

## Mini.nvim modules in use

`mini.ai`, `mini.comment`, `mini.move`, `mini.surround`, `mini.cursorword`, `mini.indentscope`, `mini.pairs`, `mini.trailspace`, `mini.bufremove`, `mini.notify`, `mini.icons`, `mini.diff` (git signs + hunk navigation), `mini.git` (blame/show).

## Floating terminal

A custom floating terminal (80%×80% of the editor) is toggled with `<leader>t`. The terminal buffer is reused across toggles (hidden, not destroyed). In terminal mode: `<Esc>` exits to normal mode, `<C-q>` closes the window.

## Key keymaps (leader = `<Space>`)

| Key | Action |
|-----|--------|
| `<leader>ff/fg/fb/fh` | fzf-lua: files / live grep / buffers / help |
| `<leader>fx/fX` | fzf-lua: diagnostics (document / workspace) |
| `<leader>gd/gD/gS` | LSP: go to definition (fzf / direct / vsplit) |
| `<leader>fr/ft/fs/fw/fi` | fzf-lua: LSP references / typedefs / doc symbols / workspace symbols / implementations |
| `<leader>ca / <leader>rn` | LSP: code action / rename |
| `<leader>oi` | LSP: organize imports then format |
| `<leader>d / <leader>D` | Diagnostics: cursor / line float |
| `<leader>q` | Open diagnostic loclist |
| `<leader>nd / <leader>pd` | Next / prev diagnostic |
| `<leader>td` | Toggle diagnostics on/off |
| `<leader>e` | Toggle nvim-tree |
| `<leader>tt` | Toggle floating terminal |
| `<leader>hs / ]h / [h` | Git: stage hunk / next hunk / prev hunk (mini.diff) |
| `<leader>hp` | Git: toggle diff overlay (mini.diff) |
| `<leader>hb` | Git: blame / show at cursor (mini.git) |
| `<leader>nn/nf/ns/nt/nw` | Obsidian: new note / find / search / today / workspace |
| `<leader>bn / <leader>bp` | Next / prev buffer |
| `<leader>sv / <leader>sh` | Split window vertically / horizontally |
| `<leader>pa` | Copy full file path to clipboard |
| `<leader>c` | Clear search highlights |
| `<leader>x` | Delete without yanking (normal + visual) |
| `<leader>p` | Paste without yanking (visual) |
| `<A-j/k>` | Move line / selection down / up |
| `<C-h/j/k/l>` | Window navigation |
| `<C-Up/Down/Left/Right>` | Resize window |
| `K` | LSP hover |

## Notes (Obsidian)

Workspace is hardcoded to `~/Documents/Auke`.

## Colorscheme

Gruvbox (`ellisonleao/gruvbox.nvim`) with lualine using the gruvbox theme. `set_transparent()` is called immediately after `vim.cmd.colorscheme("gruvbox")` so gruvbox does not override the transparency. NvimTree and floating terminal highlight groups are additionally overridden inline after their respective setups.
