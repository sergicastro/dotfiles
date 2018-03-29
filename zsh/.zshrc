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
COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git colored-man colorize heroku mvn pip python redis-cli vagrant knife kitchen bundle)

source $ZSH/oh-my-zsh.sh

#### Customize to your needs...
setopt no_share_history

# source ~/.zsh/aliases
source ~/.dotfiles/zsh/aliases

# autocomplete ..
zstyle ':completion:*' special-dirs true

# Define the PATH
export M2_HOME=~/Programs/maven
export PATH=$PATH:$M2_HOME/bin:/usr/local/mysql/bin:$HOME/scripts
export MAVEN_OPTS="-Xms512m -Xmx1024m"
# java 8 deprecated
# "-XX:PermSize=256m -XX:MaxPermSize=1024m"
export TERM=xterm-256color
export DOTFILES_PATH="$HOME/.dotfiles"
export MY_WORKSPACE="$HOME/"

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

### Jenv
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

export JAVA_HOME=/usr

### rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

### Check for git repos update (after rbenv)
update_gitrepos.rb

### gradle
export GRADLE_HOME=/opt/gradle
export PATH="$GRADLE_HOME/bin:$PATH"

### chef
# eval "$(chef shell-init zsh)"

### the fuck
eval $(thefuck --alias)

### Go
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

### TILIX VTE (terminal emulator)
if ([ $TILIX_ID ] || [ $VTE_VERSION ]) && [ -f /etc/profile.d/vte.sh ] ; then
  source /etc/profile.d/vte.sh
fi
