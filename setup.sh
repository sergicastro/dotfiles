#!/bin/bash

set -x

# When you have a task to run that will take a large (or unknown) amount of time invoke it in a background subshell like this:
#	(a_long_running_task) &
# Then, immediately following that invocation, call the spinner and pass it the PID of the subshell you invoked.
#	spinner $!
function spinner()
{
    local pid=$1
    local delay=0.75
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

function check_install(){
    name=$1
    check=$2
    install=$3
    $check 2>&1 > /dev/null
    if [[ $? == 0 ]]; then
        echo "$name already installed"
    else
        echo "Installing $name via $install"
        $install 2>&1 > /dev/null &
        spinner $!
        if [[ $? == 0 ]]; then
            echo "$name succesfully installed"
        else
            echo "ERROR: cannot install $name"
            return $?
        fi
    fi
}




## START INSTALLATION ##
check_install git "git --version"  "sudo apt-get install git -y"

git clone http://github.com/robbyrussell/oh-my-zsh.git  ~/.oh-my-zsh

ln -s ~/.dotfiles/git/.gitconfig ~/.gitconfig
ln -s ~/.dotfiles/git/templatedir/ ~/.gittemplate

check_install zsh "zsh --version"  "sudo apt-get install zsh -y"
chsh -s /usr/bin/zsh

ln -s ~/.dotfiles/scripts/ ~/scripts
ln -s ~/.dotfiles/zsh/.zshrc ~/.zshrc
ln -s ~/.dotfiles/zsh/themes/scastro.zsh-theme ~/.oh-my-zsh/themes/scastro.zsh-theme

ln -s ~/.dotfiles/vim/.vim ~/.vim
ln -s ~/.dotfiles/vim/.vimrc ~/.vimrc
