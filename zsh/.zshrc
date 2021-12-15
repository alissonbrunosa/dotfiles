export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="alisson"

plugins=(git autojump systemd bundler)

source $ZSH/oh-my-zsh.sh

fpath+=${ZDOTDIR:-~}/.zsh_functions

if command -v tmux &> /dev/null && [ -z "$TMUX" ] && [ -n "$DISPLAY" ] && [[ -o  interactive ]]; then
    tmux new -A -s Main
fi

source $HOME/.aliases

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
