#!/bin/bash

# The install script for my dotfiles. Links up all of my dotfiles
# to the correct location for their execution for one step setup
# on a new machine

if [[ $UID != 0 ]]; then
    echo "Please run this script with sudo:"
    echo "sudo $0 $*"
    exit 1
fi

# Get the current directory of the install script
SCRIPT_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ "$(uname -s)" == "Darwin" ]
then
    OLD_PATH=$PATH
    export PATH=$SCRIPT_DIRECTORY/bin:$PATH
fi

# Get the directory of the user
USER_HOME="$(getent passwd $SUDO_USER | cut -d: -f6)"

echo "Linking vimrc from $SCRIPT_DIRECTORY to $USER_HOME"
sudo -u $USERNAME ln -s $SCRIPT_DIRECTORY/vimrc $USER_HOME/.vimrc

echo "Linking vim from $SCRIPT_DIRECTORY to $USER_HOME"
sudo -u $USERNAME ln -s $SCRIPT_DIRECTORY/vim/ $USER_HOME/.vim

if [ "$(uname -s)" == "Darwin" ]
then
    export PATH=$OLD_PATH
fi
