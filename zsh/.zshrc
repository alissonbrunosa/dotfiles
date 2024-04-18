export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="alisson"

plugins=(git autojump systemd bundler asdf)

source $ZSH/oh-my-zsh.sh

fpath+=${ZDOTDIR:-~}/.zsh_functions

if [[ -n "$(command -v zellij)" && -z "$ZELLIJ" && -n "$DISPLAY" && -o interactive ]]; then
    zellij attach Main --create
fi

source $HOME/.aliases

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.zsh.extras ] && source ~/.zsh.extras
