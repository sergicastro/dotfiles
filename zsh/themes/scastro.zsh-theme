# scastro zsh theme

function my_git_prompt() {
  tester=$(git rev-parse --git-dir 2> /dev/null) || return
  
  INDEX=$(git status --porcelain 2> /dev/null)
  STATUS=""

  # is branch ahead?
  if $(echo "$(git log origin/$(current_branch)..HEAD 2> /dev/null)" | grep '^commit' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_AHEAD"
  fi

  # is anything staged?
  if $(echo "$INDEX" | grep -E -e '^(D[ M]|[MARC][ MD]) ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_STAGED"
  fi

  # is anything unstaged?
  if $(echo "$INDEX" | grep -E -e '^[ MARC][MD] ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNSTAGED"
  fi

  # is anything untracked?
  if $(echo "$INDEX" | grep '^?? ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNTRACKED"
  fi

  # is anything unmerged?
  if $(echo "$INDEX" | grep -E -e '^(A[AU]|D[DU]|U[ADU]) ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNMERGED"
  fi

  # choose color dependen on clean branch
  if [[ -n $STATUS ]];
    then ZSH_GIT_CUST_BRANCH="%{$fg_bold[yellow]%}$(my_current_branch) ";
    else ZSH_GIT_CUST_BRANCH="%{$fg_bold[cyan]%}$(my_current_branch) %{$fg_bold[green]%}✔";

  fi

  echo "$ZSH_THEME_GIT_PROMPT_PREFIX$ZSH_GIT_CUST_BRANCH$STATUS$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

function my_current_branch() {
  echo $(current_branch || echo "(no branch)")
}

function ssh_connection() {
  if [[ -n $SSH_CONNECTION ]]; then
    echo "%{$fg_bold[red]%}(ssh) "
  fi
}

local ret_status="%(?:%{$fg_bold[green]%}:%{$fg_bold[red]%})%?%{$reset_color%}"

# git theming
ZSH_THEME_PROMPT_RETURNCODE_PREFIX="%{$fg_bold[red]%}"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg_bold[magenta]%}↑"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg_bold[green]%}⚡"
ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$fg_bold[red]%}⚡"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[white]%}⚡"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg_bold[red]%}✕"
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[gray]%}<%{$fg_bold[yellow]%} "
ZSH_THEME_GIT_PROMPT_SUFFIX=" %b%{$fg_bold[gray]%}>%{$reset_color%}"

# features:
# path is autoshortened to ~30 characters
# displays git status (if applicable in current folder)
# turns username green if superuser, otherwise it is white

# if superuser make the username green
if [ $UID -eq 0 ]; then NCOLOR="green"; else NCOLOR="red"; fi

# prompt
PROMPT='$(ssh_connection)%{$fg[$NCOLOR]%}%n@%m%{$reset_color%}:%{$fg[white]%}%30<...<%~%<<%{$reset_color%} %B>>%b '
RPROMPT='$(my_git_prompt)'
