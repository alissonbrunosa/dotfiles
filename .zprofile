setopt HISTAPPEND
eval $(dircolors ~/.dir_colors)

if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
    tmux new -A -s Main
fi
