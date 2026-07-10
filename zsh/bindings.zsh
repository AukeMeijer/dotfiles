# =========================================================
# Keybindings
# =========================================================

# Ctrl+Right -> move forward one word (^[[1;5C is the terminal escape code)
bindkey '^[[1;5C' forward-word

# Ctrl+Left -> move backward one word (^[[1;5D is the terminal escape code)
bindkey '^[[1;5D' backward-word

# Ctrl+F -> fzf file picker (no hidden files)
bindkey '^F' _fzf_file_no_hidden

# Ctrl+\ -> toggle autosuggestions (useful for screen recordings)
bindkey '^\' autosuggest-toggle

# Up/Down -> history search by substring (^[[A/^[[B are up/down arrow escape codes)
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Ctrl+R -> fzf fuzzy history search
bindkey '^R' fzf-history-widget
