# =========================================================
# fzf
# =========================================================

export FZF_DEFAULT_COMMAND='fd --type f --hidden --strip-cwd-prefix'  # strip-cwd-prefix removes the leading ./ from results

# UI
export FZF_DEFAULT_OPTS='
  --height=60%
  --layout=reverse
  --border=rounded
  --prompt="  "
  --pointer="  "
  --preview-window=right:65%:wrap:border-left
  --color=bg+:#3c3836,bg:#282828,fg:#ebdbb2,fg+:#ebdbb2,hl:#fabd2f,hl+:#fabd2f,info:#83a598,prompt:#b8bb26,pointer:#fb4934,marker:#8ec07c,spinner:#8ec07c,header:#a89984,border:#3c3836
'

_FZF_PREVIEW_CMD='bat --color=always --style=plain,numbers --line-range=:500 {}'

# Ctrl+F: file picker excluding hidden files
_fzf_file_no_hidden() {
  local cmd result
  cmd="${FZF_DEFAULT_COMMAND/--hidden /}"
  result=$(eval "${cmd:-find . -type f}" | fzf --preview "$_FZF_PREVIEW_CMD") \
    && LBUFFER+="$result"  # LBUFFER is the text left of the cursor
  zle reset-prompt
}
zle -N _fzf_file_no_hidden
