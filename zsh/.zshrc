export ZSH="$HOME/.oh-my-zsh"
# export ZDOTDIR="$HOME/.zsh"

ZSH_THEME="alisson"

plugins=(git autojump systemd cm)

source $ZSH/oh-my-zsh.sh

autoload -Uz compinit && compinit

fpath+=${ZDOTDIR:-~}/.zsh_functions

autoload -U compinit
compinit

source $HOME/.aliases

[ -f ~/.zsh.extras ] && source ~/.zsh.extras
[ -f ~/.start-zellij ] && source ~/.start-zellij
