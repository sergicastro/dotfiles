#!/bin/bash

ls -l $HOME/.dotfiles > /dev/null 2>&1
if [[ $? == 0 ]]; then
    echo "dotfiles project already exist in $HOME/.dofiles"
    echo "delete it and run again install.sh or"
    echo "run $HOME/.dotfiles/setup/setup.sh"
    exit -1
fi

unzip -v > /dev/null 2>&1
if [[ $? != 0 ]]; then
    echo "unzip program is required to get the dotfiles project"
    echo "do you want to install it now via apt-get? [y/N]"
    read response
    if [[ "$response" == "y" ]] || [[ "$response" == "Y" ]]; then
        sudo apt-get install unzip -y > /dev/null 2>&1
    else
        echo "Install unzip before continue"
        exit -1
    fi
fi

set -e
wget https://github.com/sergicastro/dotfiles/archive/master.zip -O /tmp/dotfiles.zip
unzip /tmp/dotfiles.zip -d /tmp
mv -v /tmp/dotfiles-master $HOME/.dotfiles
$HOME/.dotfiles/setup/setup.sh
