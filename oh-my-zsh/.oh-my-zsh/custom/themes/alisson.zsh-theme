function prompt_setup() {
  local fg="%F{#D8DEE9}"
  local blue="%F{#5E81AC}"
  local purple="%F{#BF40BF}"
  local red="%F{#BF616A}"
  local orange="%F{#D08770}"
  local yellow="%F{#EBCB8B}"
  local green="%F{#A3BE8C}"
  local reset="%f%b%k"  # Reset all attributes

  # Prompt Symbols
  local newline=$'\n'
  local separator=" %{☷%} "
  local prompt_symbol="❯"
  local error_symbol="💥"

  ZSH_THEME_GIT_PROMPT_DIRTY="${separator}[${orange}+${reset}]"
  ZSH_THEME_GIT_PROMPT_CLEAN="${separator}[${green}✓${reset}]"

  # Command Return Code: Display error if last command failed
  local return_code="%(?..${red}${error_symbol} %?${reset})"

  # Git Information Display
  local git_info=""
  if [[ -n $(git_current_branch) ]]; then
    git_info="${green} $(git_current_branch)${reset}$(parse_git_dirty)${reset}"
  fi

  # Combine PS1 Components
  PS1="${return_code}${newline}${purple}${prompt_symbol} ${reset}"
  RPS1="${git_info}${reset}"

  # Continuation Prompt for Multiline Commands
  PS2="${red} \\ ${reset}"
}

prompt_setup
autoload -Uz add-zsh-hook
add-zsh-hook precmd prompt_setup
