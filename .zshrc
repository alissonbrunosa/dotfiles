export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="af-magic"
plugins=(git autojump docker docker-compose)
source $ZSH/oh-my-zsh.sh

# Aliases
alias vim="vimx"
alias zshconfig="vim ~/.zshrc"
alias ohmyzsh="vim ~/.oh-my-zsh"
alias python="python3"
alias commit='git commit -m "$(curl -s whatthecommit.com/index.txt)"'

fpath+=${ZDOTDIR:-~}/.zsh_functions

source $HOME/.exports

eval "$(rbenv init -)"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
