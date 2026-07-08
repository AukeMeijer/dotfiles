# VS Code Configuration

This VS Code configuration mirrors the current Neovim setup (`../nvim/init.lua`) as closely as VS Code + the Vim extension allow. It is resynced whenever the Neovim config changes meaningfully — treat `nvim/init.lua` as the source of truth and this file/config as the derived copy.

## Required Extensions

**Essential:**
```bash
ext install vscodevim.vim
ext install jdinhlife.gruvbox
```

**Language Support:**
```bash
# C/C++ (clangd, matching Neovim's clangd LSP)
ext install llvm-vs-code-extensions.vscode-clangd
```

**Recommended (used by some keybindings above but not required to start):**
```bash
ext install eamodio.gitlens   # powers <leader>hb (blame)
```

Or via Command Palette: `Cmd+Shift+P` → "Extensions: Install Extensions"

## Configuration Location

`~/Library/Application Support/Code/User/settings.json` and `keybindings.json` are symlinked to `~/.config/vscode/settings.json` and `~/.config/vscode/keybindings.json` for dotfiles management. Edit the files here, not the ones under `Library/Application Support`.

## Keybinding Reference

### Leader Key: `Space`

Leader-prefixed sequences live in `settings.json` under `vim.normalModeKeyBindingsNonRecursive` / `vim.visualModeKeyBindingsNonRecursive` (only the Vim extension can parse `<leader>` chords). Plain Ctrl/Alt/Cmd chords live in `keybindings.json`.

| Keybinding | Action | Neovim Equivalent |
|------------|--------|-------------------|
| `<leader>c` | Clear search highlights | `<leader>c` |
| `<leader>x` | Delete without yanking (normal + visual) | `<leader>x` |
| `<leader>p` | Paste without yanking replaced text (visual) | `<leader>p` |
| `<leader>bn` / `<leader>bp` | Next / previous buffer | `<leader>bn` / `<leader>bp` |
| `<leader>e` | Toggle sidebar (closest match to nvim-tree toggle) | `<leader>e` |
| `<leader>pa` | Copy full file path to clipboard | `<leader>pa` |
| `<leader>sv` / `<leader>sh` | Split editor vertically / horizontally | `<leader>sv` / `<leader>sh` |
| `<leader>tt` | Toggle terminal | `<leader>tt` |

### fzf-lua (find/search)

| Keybinding | Action | Neovim Equivalent |
|------------|--------|-------------------|
| `<leader>ff` | Quick open (files) | `<leader>ff` (fzf-lua files) |
| `<leader>fg` | Find in files (grep) | `<leader>fg` (fzf-lua live_grep) |
| `<leader>fb` | Show all open editors | `<leader>fb` (fzf-lua buffers) |
| `<leader>fh` | Command palette (closest match to help tags) | `<leader>fh` (fzf-lua help_tags) |
| `<leader>fx` / `<leader>fX` | Problems panel (VS Code doesn't separate document vs. workspace scope by keybinding alone — use the panel's filter) | `<leader>fx` / `<leader>fX` |

### LSP

| Keybinding | Action | Neovim Equivalent |
|------------|--------|-------------------|
| `K` | Hover documentation | `K` |
| `<leader>gd` | Go to definition | `<leader>gd` (fzf-lua lsp_definitions) |
| `<leader>gD` | Peek definition | `<leader>gD` (direct definition) |
| `<leader>gS` | Go to definition in a side split | `<leader>gS` (vsplit + definition) |
| `<leader>ca` | Code action / quick fix | `<leader>ca` |
| `<leader>rn` | Rename symbol | `<leader>rn` |
| `<leader>oi` | Organize imports | `<leader>oi` |
| `<leader>fr` | Find references | `<leader>fr` |
| `<leader>ft` | Go to type definition | `<leader>ft` |
| `<leader>fs` | Document symbols | `<leader>fs` |
| `<leader>fw` | Workspace symbols | `<leader>fw` |
| `<leader>fi` | Go to implementation | `<leader>fi` |

### Diagnostics

| Keybinding | Action | Neovim Equivalent |
|------------|--------|-------------------|
| `<leader>d` / `<leader>D` | Show hover (closest match to a diagnostic float at cursor/line — VS Code has no separate cursor/line-scoped diagnostic float) | `<leader>d` / `<leader>D` |
| `<leader>nd` / `<leader>pd` | Next / previous diagnostic marker | `<leader>nd` / `<leader>pd` |
| `<leader>q` | Open Problems panel | `<leader>q` (diagnostic loclist) |

`<leader>td` (toggle diagnostics on/off) has no built-in VS Code equivalent and is intentionally not mapped.

### Git (mini.diff + mini.git)

| Keybinding | Action | Neovim Equivalent |
|------------|--------|-------------------|
| `]h` / `[h` | Next / previous changed hunk | `]h` / `[h` (mini.diff) |
| `<leader>hs` | Stage hunk / selected range (normal + visual) | `<leader>hs` (MiniDiff.operator) |
| `<leader>hp` | Open inline change preview | `<leader>hp` (toggle diff overlay) |
| `<leader>hb` | Toggle line blame (requires GitLens) | `<leader>hb` (mini.git show_at_cursor) |

### Window Navigation (Ctrl+hjkl)

| Keybinding | Action | Neovim Equivalent |
|------------|--------|-------------------|
| `Ctrl+h/j/k/l` | Focus left/below/above/right editor group (or terminal pane) | `<C-h/j/k/l>` |

### Move Lines / Indent (mini.move)

| Keybinding | Action | Neovim Equivalent |
|------------|--------|-------------------|
| `Alt+j` / `Alt+k` | Move line/selection down / up (normal + visual) | `<M-j>` / `<M-k>` |
| `Alt+h` / `Alt+l` | Outdent / indent line or selection (normal + visual) | `<M-h>` / `<M-l>` |
| `Alt+Down` / `Alt+Up` | Move line down / up (fallback if Vim extension is off) | — |

### Window Resize

| Keybinding | Action | Neovim Equivalent |
|------------|--------|-------------------|
| `Ctrl+Up` / `Ctrl+Down` | Increase / decrease view height | `<C-Up>` / `<C-Down>` |
| `Ctrl+Left` / `Ctrl+Right` | Decrease / increase view width | `<C-Left>` / `<C-Right>` |

macOS Mission Control also defaults to Ctrl+Left/Right for switching Spaces, which can steal these — disable that in System Settings → Keyboard → Shortcuts if resize doesn't fire.

### Completion (blink.cmp)

| Keybinding | Action | Neovim Equivalent |
|------------|--------|-------------------|
| `Ctrl+Space` | Show / hide completion menu | `<C-Space>` |
| `Enter` | Accept completion | `<CR>` |
| `Ctrl+j` / `Ctrl+k` | Select next / previous item | `<C-j>` / `<C-k>` |
| `Tab` / `Shift+Tab` | Snippet forward / backward (VS Code default when in snippet mode, no override needed) | `<Tab>` / `<S-Tab>` |

### Terminal

| Keybinding | Action | Neovim Equivalent |
|------------|--------|-------------------|
| `<leader>tt` | Toggle terminal | `<leader>tt` |
| `Ctrl+q` | Close terminal (while terminal focused) | `<C-q>` |
| `Esc` | Exit to Normal mode in terminal | Not reliably supported — VSCodeVim's terminal-mode emulation is limited (see Differences below) |

### VS Code-only additions

These are not derived from `nvim/init.lua` — they're kept as general editor conveniences and don't claim Neovim parity:

| Keybinding | Action |
|------------|--------|
| `Ctrl+s` | Save file |
| `Alt+a` | Select all |
| `Cmd+\` | Split editor right |
| `Cmd+-` | Split editor down |
| `Ctrl+\` | Toggle terminal (alternate to `<leader>tt`) |
| `j` then `k` (insert mode) | Exit to Normal mode |

Standard Vim fold commands (`zo`, `zc`, `zM`, `zR`, etc.) work out of the box via the Vim extension's native emulation — no custom keybinding needed, matching Neovim's treesitter-based folding (`foldlevel = 99`, folds start open).

## Editor Settings Matching Neovim

| Setting | Value | Neovim Option |
|---------|-------|---------------|
| Relative line numbers | On | `vim.opt.relativenumber` |
| Cursor surrounding lines | 15 | `vim.opt.scrolloff = 15` |
| Cursor style | Block | `vim.opt.guicursor` (block in normal mode) |
| Smart case search | On | `vim.opt.smartcase` |
| Split direction | Right | `vim.opt.splitright` |
| Whitespace rendering | Boundary | `vim.opt.list` |
| Word separators | Excludes `-` | `vim.opt.iskeyword:append("-")` |
| Format on save | On | efm-langserver `BufWritePre` autocmd |
| Tab size | 2 spaces | `vim.opt.tabstop/shiftwidth = 2` |
| Vim leader timeout | 500ms | `vim.opt.timeoutlen = 500` |
| Minimap | Off | — |
| Theme | Gruvbox Dark Medium | `gruvbox.nvim` (default/medium contrast) |
| Font (editor) | MesloLGS NF | — |
| Font (terminal) | MesloLGS Nerd Font Mono | Matches Ghostty |

`gruvbox.nvim` is loaded with `set_transparent()` in Neovim, which makes editor chrome transparent over the terminal background. VS Code has no equivalent without third-party window hacks, so this config instead pins the standard gruvbox background color (`#282828`) everywhere.

## Semantic Token Highlighting

VS Code is configured with semantic token colors matching the gruvbox palette for consistent syntax highlighting (particularly useful for C#, which relies heavily on semantic tokens).

**Configuration:** `editor.semanticTokenColorCustomizations` in `settings.json`

| Token Type | Color | Hex Code |
|------------|-------|----------|
| Classes/Structs/Types | Yellow | `#fabd2f` |
| Interfaces | Aqua | `#8ec07c` |
| Enums | Yellow | `#fabd2f` |
| Enum Members | Aqua | `#8ec07c` |
| Functions/Methods | Blue | `#83a598` |
| Properties | Aqua | `#8ec07c` |
| Variables/Parameters | Default | `#ebdbb2` |
| Namespaces | Purple | `#d3869b` |
| Keywords/Modifiers | Red | `#fb4934` |
| Strings | Green | `#b8bb26` |
| Numbers | Orange | `#fe8019` |
| Comments | Gray (italic) | `#928374` |
| Operators | Aqua | `#8ec07c` |

## Vim Extension Features Enabled

- **vim.surround**: `ys`, `cs`, `ds` for surrounding text (matches mini.surround)
- **vim.highlightedyank**: Brief highlight when yanking (matches the `TextYankPost` autocmd)
- **vim.useSystemClipboard**: Sync with OS clipboard (matches `vim.opt.clipboard:append("unnamedplus")`)

## Disabled Ctrl Keys

These Ctrl keys are passed through to VS Code instead of the Vim extension (`vim.handleKeys` in `settings.json`):

`Ctrl+A` (select all), `Ctrl+C` (copy), `Ctrl+V` (paste), `Ctrl+X` (cut), `Ctrl+F` (find), `Ctrl+Z` (undo), `Ctrl+Y`/`Ctrl+N`/`Ctrl+P`/`Ctrl+E` (completion/quick-open navigation).

## Differences from Neovim

Some features cannot be perfectly replicated:

1. **nvim-tree**: VS Code's built-in Explorer sidebar toggle is the closest match — no floating tree, no custom filters.
2. **fzf-lua**: Approximated with VS Code's Quick Open / Find in Files / command palette; no fuzzy-matched preview pane.
3. **mini.clue**: No which-key-style popup showing available leader sequences.
4. **mini.ai**: Enhanced/custom text objects are not available; only VS Code + VSCodeVim's built-in text objects.
5. **Obsidian notes** (`<leader>nn/nf/ns/nt/nw`): No equivalent configured in VS Code.
6. **Floating terminal**: VS Code's integrated terminal is a panel, not a floating window; `Esc`-to-Normal-mode inside the terminal is not reliably supported by the Vim extension.
7. **True background transparency**: Not supported without third-party window hacks; a solid gruvbox background is used instead.
8. **efm-langserver formatters/linters**: VS Code formats per-language via each language's own extension/formatter setting rather than a single external formatter process.

## Language Support

Only C/C++ has a direct 1:1 Neovim LSP match (`clangd`, enabled in both). Other languages below are convenience setups for VS Code and are not driven by the Neovim config, which currently only enables `lua_ls`, `pyright`, `bashls`, `ts_ls`, `gopls`, `clangd`, `efm`, plus `rust-analyzer` via `rustaceanvim`.

### C/C++

**Extension:** `llvm-vs-code-extensions.vscode-clangd` (clangd language server)

**Configuration:** matches Neovim's `vim.lsp.config("clangd", ...)` — background indexing, `--clang-tidy`, `--header-insertion=iwyu`, detailed completion style, function argument placeholders. Formatting is delegated to clangd on save (Neovim uses `clang_format` + `cpplint` via efm instead).

**Setup:**
1. Install clangd extension: `ext install llvm-vs-code-extensions.vscode-clangd`
2. Install clangd on system (macOS: `brew install llvm`)
3. Open a C/C++ file — clangd activates automatically

### JavaScript/TypeScript

**Built-in support.** Neovim uses `ts_ls` + `eslint_d`/`prettier_d` via efm. For matching formatting behavior in VS Code, install:
```bash
ext install esbenp.prettier-vscode
ext install dbaeumer.vscode-eslint
```

### Python

Neovim uses `pyright` + `flake8`/`black` via efm. For matching behavior in VS Code, install:
```bash
ext install ms-python.python
ext install ms-python.vscode-pylance
```

### Lua / Go / Shell / Rust

These have no additional VS Code setup documented here beyond the built-in/standard extensions (`lua_ls`, `gopls`, `rust-analyzer` are common enough to have first-class VS Code extensions if needed). Not required for the base config to work.

### PHP / C#

Configured in `settings.json` (`php.validate.executablePath`, `phpTools.language`, C# semantic token colors) as pre-existing user preferences — the Neovim config has no PHP or C# LSP/formatter set up, so there's no parity target for these; they're VS Code-only.

## Recommended Additional Extensions

- `vscode-icons-team.vscode-icons` — file icons (matches `mini.icons`)
- `streetsidesoftware.code-spell-checker` — spell checking
- `eamodio.gitlens` — powers `<leader>hb` (blame)
