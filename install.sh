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

echo "Installing Packages"
apt-get update
apt-get install python-software-properties python g++ make gcc mongodb git vim -y
add-apt-repository ppa:chris-lea/node.js -y

if xset q &>/dev/null; then
	add-apt-repository "ppa:webupd8team/sublime-text-2" -y
fi

apt-get update
apt-get install nodejs -y

if xset q &>/dev/null; then
	apt-get install sublime-text
fi	

echo "Linking bash_aliases from $SCRIPT_DIRECTORY to $HOME"
sudo -u $USERNAME ln -s $SCRIPT_DIRECTORY/bash_aliases $HOME/.bash_aliases

echo "Linking gitconfig from $SCRIPT_DIRECTORY to $HOME"
sudo -u $USERNAME ln -s $SCRIPT_DIRECTORY/gitconfig $HOME/.gitconfig

echo "Linking tmux.conf from $SCRIPT_DIRECTORY to $HOME"
sudo -u $USERNAME ln -s $SCRIPT_DIRECTORY/tmux.conf $HOME/.tmux.conf

echo "Linking vimrc from $SCRIPT_DIRECTORY to $HOME"
sudo -u $USERNAME ln -s $SCRIPT_DIRECTORY/vimrc $HOME/.vimrc

echo "Linking vim from $SCRIPT_DIRECTORY to $HOME"
sudo -u $USERNAME ln -s $SCRIPT_DIRECTORY/vim/ $HOME/.vim

echo "Removing sublime text 2 default config"
sudo -u $USERNAME rm -r "$HOME/.config/sublime-text-2/Packages/User"

echo "Linking Sublime Text from $SCRIPT_DIRECTORY to $HOME"
sudo -u $USERNAME ln -s $SCRIPT_DIRECTORY/sublime/User "$HOME/.config/sublime-text-2/Packages/User"
