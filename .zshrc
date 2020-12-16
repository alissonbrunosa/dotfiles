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

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export EDITOR="vim"
export PATH="$PATH:$HOME/.rvm/bin"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$GOPATH/bin"
export GOPATH="$HOME/code/go"
export KUBECONFIG=$HOME/.kube/config:$HOME/.kube/development_config:$KUBECONFIG
export FZF_DEFAULT_COMMAND="rg --files"
