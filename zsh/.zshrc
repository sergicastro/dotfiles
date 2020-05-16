# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="scastro"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Uncomment this to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git colored-man-pages colorize heroku mvn pip python redis-cli vagrant knife kitchen bundle go docker)

source $ZSH/oh-my-zsh.sh

#### Customize to your needs...
setopt no_share_history

# source ~/.zsh/aliases
source ~/.dotfiles/zsh/aliases
local custom_aliases="$HOME/.custom-aliases"
if [[ -f "$custom_aliases" ]]; then
  source $custom_aliases
elif [[ -d "$custom_aliases" ]]; then
  source $custom_aliases/*
fi

# autocomplete ..
zstyle ':completion:*' special-dirs true

# Define the PATH
#export M2_HOME=~/Programs/maven
export PATH=$PATH:$M2_HOME/bin:/usr/local/mysql/bin:$HOME/scripts
#export MAVEN_OPTS="-Xms512m -Xmx1024m"
# java 8 deprecated
# "-XX:PermSize=256m -XX:MaxPermSize=1024m"
export TERM=xterm-256color
export DOTFILES_PATH="$HOME/.dotfiles"
#export MY_WORKSPACE="$HOME/"
export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

### Jenv
export PATH="$HOME/.jenv/bin:$PATH"
#eval "$(jenv init -)"

### rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
#eval "$(rbenv init -)"

### Go
export GOPATH=$HOME/go
export GOPRIVATE=github.com/tetrateio/*
export GOPROXY=https://proxy.golang.org,direct
export PATH=$PATH:$GOPATH/bin

### TILIX VTE (terminal emulator)
if ([ $TILIX_ID ] || [ $VTE_VERSION ]) && [ -f /etc/profile.d/vte.sh ] ; then
  source /etc/profile.d/vte.sh
fi

export EDITOR=vim
export GPG_TTY=`tty`

## k8s
source <(kubectl completion zsh)
alias k=kubectl
complete -o default -F __start_kubectl k
source <(helm completion zsh)
source $HOME/kube-ps1/kube-ps1.sh

# istio
export PATH=~/istio/bin:$PATH
source $HOME/istio/tools/_istioctl

export PATH=$PATH:/opt/protoc/bin
export PATH="$PATH:/usr/local/opt/node@10/bin"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/sergicastro/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/sergicastro/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/sergicastro/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/sergicastro/google-cloud-sdk/completion.zsh.inc'; fi