export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="af-magic"
plugins=(git autojump docker docker-compose)
source $ZSH/oh-my-zsh.sh

fpath+=${ZDOTDIR:-~}/.zsh_functions

if command -v tmux &> /dev/null && [ -z "$TMUX" ] && [ -n "$DISPLAY" ] && [[ -o  interactive ]]; then
    tmux new -A -s Main
fi


eval "$(rbenv init -)"
eval "$(dircolors ~/.dir_colors)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
