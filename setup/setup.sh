#!/bin/bash

set -e

use_colors="[[ \"$(tput colors)\" -gt \"0\" ]]"

function print_color()
{
    code=$1
    message=${*:2}
    if eval $use_colors ; then
        echo -e "\e[$(echo $code)m$message\e[0m"
    else
        echo $message
    fi
}

function log()
{
    print_color 96 $1
}

function error()
{
    print_color 91 $1
}

function success()
{
    print_color 92 $1
}


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

function check_install()
{
    set +e
    name=$1
    check=$2
    install=$3
    $check 2>&1 > /dev/null
    if [[ $? == 0 ]]; then
        success "$name already installed"
    else
        log "Installing $name via $install"
        $install 2>&1 > /dev/null &
        spinner $!
        if [[ $? == 0 ]]; then
            success "$name successfully installed"
        else
            error "ERROR: cannot install $name"
            return $?
        fi
    fi
    set -e
}

function check_ln()
{
    set +e
    origin=$1
    destination=$2
    ls $destination 2>&1 > /dev/null
    if [[ $? == 0 ]]; then
        success "link $destination already created"
    else
        ln -s $origin $destination
        success "link $destination created"
    fi
    set -e
}

function check_git_clone()
{
    set +e
    origin=$1
    destination=$2
    ls $destination 2>&1 > /dev/null
    if [[ $? == 0 ]]; then
        success "git repo $origin already created on $destination"
    else
        git clone $origin $destination
    fi
    set -e
}


# LOAD PLUGINS
plugins_path="$HOME/.dotfiles/plugins"
plugins=$(ls $plugins_path)
log "we're gonna install: $plugins"
for plugin in $plugins
do
    log "loading $plugin..."
    source $plugins_path/$plugin
    $(echo $plugin)_load
done
