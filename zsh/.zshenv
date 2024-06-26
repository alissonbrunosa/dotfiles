#!/usr/bin/env sh

export EDITOR="vimx"

# Go
export GOPATH="$HOME/Code/Go"

# PATH
smart_export () {
    case ":${PATH}:" in
        *:"$1":*)
           return 0
           ;;
        *)
            if [ "$2" = "after" ] ; then
                export PATH=$PATH:$1
            else
                export PATH=$1:$PATH
            fi
    esac
}

smart_export "$HOME/.local/bin"        after
smart_export "$HOME/.local/bin/go/bin" after
smart_export "$HOME/.rbenv/bin"        after
smart_export "$HOME/.nodenv/bin"       after
smart_export "$GOPATH/bin"             after
smart_export "$HOME/.cargo/bin"        after
smart_export "$HOME/spicetify-cli"     after
smart_export "/usr/local/bin"          after
smart_export "/usr/local/go/bin"       after
unset -f smart_export

# K8s
export KUBECONFIG=$HOME/.kube/config:$HOME/.kube/development_config:$KUBECONFIG

# Fzf
export FZF_DEFAULT_COMMAND="rg --files"

# History
# http://unix.stackexchange.com/a/48113
export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
export HISTSIZE=100000                   # big big history
export HISTFILESIZE=100000               # big big history

# Save and reload the history after each command finishes
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear"
export GPG_TTY=$(tty)
