#
# scastro zsh theme

function my_git_prompt() {
  tester=$(git rev-parse --git-dir 2> /dev/null) || return
  
  INDEX=$(git status --porcelain 2> /dev/null)
  STATUS=""
  HAS_STAGED=false
  HAS_UNSTAGED=false

  # is branch ahead?
  if $(echo "$(git log origin/$(current_branch)..HEAD 2> /dev/null)" | grep '^commit' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_AHEAD"
  fi

  # is anything staged?
  if $(echo "$INDEX" | grep -E -e '^(D[ M]|[MARC][ MD]) ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_STAGED";
    HAS_STAGED=true;
  fi

  # is anything unstaged?
  if $(echo "$INDEX" | grep -E -e '^[ MARC][MD] ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNSTAGED";
    HAS_UNSTAGED=true;
  fi

  # is anything untracked?
  if $(echo "$INDEX" | grep '^?? ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNTRACKED"
  fi

  # is anything unmerged?
  if $(echo "$INDEX" | grep -E -e '^(A[AU]|D[DU]|U[ADU]) ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNMERGED"
  fi
 
  # is anything renamed?
  if $(echo "$INDEX" | grep '^R' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_RENAMED"
  fi

  # choose color dependen on clean branch
  if [[ -n $STATUS ]];
    then ZSH_GIT_CUST_BRANCH="%{$fg_bold[yellow]%}$(my_current_branch) ";
    else ZSH_GIT_CUST_BRANCH="%{$fg_bold[blue]%}$(my_current_branch) %{$fg_bold[green]%}✔";
  fi

  # show diff resume when only staged files exist, too
  CACHED_OPTION=""
  if $HAS_STAGED && ! $HAS_UNSTAGED ;
    then CACHED_OPTION="--cached";
  fi

  ZSH_THEME_GIT_DIFF_RESUME=$(diff_resume)

  echo "$ZSH_THEME_GIT_DIFF_RESUME$ZSH_THEME_GIT_PROMPT_PREFIX$ZSH_GIT_CUST_BRANCH$STATUS$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

function diff_resume() {
    stats="$(git diff --shortstat $CACHED_OPTION 2> /dev/null)"
    if [ -n "$stats" ]; then
        files=$(echo "$stats" | grep "[[:digit:]]* file" -o | cut -d" " -f1)
        files=$(echo "$files""f")

        insertions=$(echo "$stats" | grep -e "[[:digit:]]* insertion" -o | cut -d" " -f1)
        if [ -z "$insertions" ];
            then insertions="0";
        fi

        deletions=$(echo "$stats" | grep -e "[[:digit:]]* deletion" -o | cut -d" " -f1)
        if [ -z "$deletions" ];
            then deletions="0";
        fi

        echo "[%B$files %{$fg[green]%}$insertions+ %{$fg[red]%}$deletions-%b] "
    fi
}

function my_current_branch() {
  echo $(current_branch || echo "(no branch)")
}

function ssh_connection() {
  if [[ -n $SSH_CONNECTION ]]; then
    echo "%{$fg[red]%}%B(ssh)%b"
  fi
}

# local ret_status="%(?:%{$fg_bold[cyan]%}:%{$fg_bold[red]%})%?%{$reset_color%}"
local ret_status="%(?::%{$fg_bold[cyan]%}%? )%{$reset_color%}"

# jenv version
function jenv_version()
{
    version=$(jenv local > /dev/null 2>&1)
    if [[ $? == 0 ]]; then
        echo "$(jenv version | cut -d" " -f1) "
    fi
}

# git theming
ZSH_THEME_PROMPT_RETURNCODE_PREFIX="%{$fg_bold[red]%}"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg_bold[magenta]%}↑"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg_bold[green]%}⚡"
ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$fg_bold[red]%}⚡"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[white]%}⚡"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[blue]%}➜"
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
PROMPT='$(ssh_connection)$ret_status%{$fg[$NCOLOR]%}%n%B@%b%{$fg[$NCOLOR]%}%m%{$reset_color%}:%{$fg[white]%}%30<...<%~%<<%{$reset_color%} %B>>%b '
RPROMPT='$(jenv_version)$(my_git_prompt)'

# LS colors, made with http://geoff.greer.fm/lscolors/
export LSCOLORS="Gxfxcxdxbxegedabagacad"
export LS_COLORS='no=00:fi=00:di=01;34:ln=00;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=41;33;01:ex=00;32:*.cmd=00;32:*.exe=01;32:*.com=01;32:*.bat=01;32:*.btm=01;32:*.dll=01;32:*.tar=00;31:*.tbz=00;31:*.tgz=00;31:*.rpm=00;31:*.deb=00;31:*.arj=00;31:*.taz=00;31:*.lzh=00;31:*.lzma=00;31:*.zip=00;31:*.zoo=00;31:*.z=00;31:*.Z=00;31:*.gz=00;31:*.bz2=00;31:*.tb2=00;31:*.tz2=00;31:*.tbz2=00;31:*.avi=01;35:*.bmp=01;35:*.fli=01;35:*.gif=01;35:*.jpg=01;35:*.jpeg=01;35:*.mng=01;35:*.mov=01;35:*.mpg=01;35:*.pcx=01;35:*.pbm=01;35:*.pgm=01;35:*.png=01;35:*.ppm=01;35:*.tga=01;35:*.tif=01;35:*.xbm=01;35:*.xpm=01;35:*.dl=01;35:*.gl=01;35:*.wmv=01;35:*.aiff=00;32:*.au=00;32:*.mid=00;32:*.mp3=00;32:*.ogg=00;32:*.voc=00;32:*.wav=00;32:'
