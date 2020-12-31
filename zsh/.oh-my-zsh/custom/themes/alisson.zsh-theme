ZSH_THEME_GIT_PROMPT_DIRTY=" *"

# copied from af-magic.zsh-theme
function dashes {
        local PYTHON_ENV="$VIRTUAL_ENV"
        [[ -z "$PYTHON_ENV" ]] && PYTHON_ENV="$CONDA_DEFAULT_ENV"

        if [[ -n "$PYTHON_ENV" && "$PS1" = \(* ]]; then
                echo $(( COLUMNS - ${#PYTHON_ENV} - 3 ))
        else
                echo $COLUMNS
        fi
}

function prompt_setup() {
        autoload -Uz add-zsh-hook
        add-zsh-hook precmd prompt_setup

        local bar="╾─╼"
        local nord3="%F{#4C566A}"
        local nord4="%F{#D8DEE9}"
        local nord8="%F{#88C0D0}"
        local nord10="%F{#5E81AC}"
        local nord11="%F{#BF616A}"
        local nord12="%F{#D08770}"
        local nord13="%F{#EBCB8B}"
        local nord14="%F{#A3BE8C}"
        local c_reset="%b%f%k"
        local return_code="%(?..${nord3}[%(?.${nord8}.${nord11})%?${nord3}]${bar}${c_reset})"
        local newline=$'\n'

        local repo_info="$(__git_prompt_git rev-parse --git-dir --is-inside-git-dir --is-bare-repository --is-inside-work-tree --short HEAD 2>/dev/null)"
        local git_info
        if [ -n "$repo_info" ]; then
          local ref
          ref=$(__git_prompt_git symbolic-ref --short HEAD 2> /dev/null) || ref=$(__git_prompt_git rev-parse --short HEAD 2> /dev/null)

          local upstream
          if (( ${+ZSH_THEME_GIT_SHOW_UPSTREAM} )); then
            upstream=$(__git_prompt_git rev-parse --abbrev-ref --symbolic-full-name "@{upstream}" 2>/dev/null) \
            && upstream=" -> ${upstream}"
          fi

          git_info="${bar}[${nord14}${ref}${upstream}${nord12}$(parse_git_dirty)${nord3}]"
        fi

        local dashes="${nord3}${(l.$(dashes)..-.)}"
        local workdir="${nord3}${bar}[${nord8}%~${nord3}]${git_info} %(!.#.»)${c_reset} "
        # primary prompt

        PS1="${dashes}${newline}${workdir}"
        PS2="${nord11} \ ${c_reset}"
        RPS1="${return_code}"

        # right prompt
        (( $+functions[virtualenv_prompt_info] )) && RPS1+='$(virtualenv_prompt_info)'
        RPS1+="${nord3}[${nord10}%n@%m${nord3}]${nord3}${bar}${c_reset}"
}

prompt_setup
