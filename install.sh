#!/bin/bash

# The install script for my dotfiles. Links up all of my dotfiles
# to the correct location for their execution for one step setup
# on a new machine

# Get the current directory of the install script
SCRIPT_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


# Link all of my configuration files

echo "Linking bash_aliases from $SCRIPT_DIRECTORY to $HOME"
ln -s $SCRIPT_DIRECTORY/bash_aliases $HOME/.bash_aliases

echo "Linking gitconfig from $SCRIPT_DIRECTORY to $HOME"
ln -s $SCRIPT_DIRECTORY/gitconfig $HOME/.gitconfig

echo "Linking tmux.conf from $SCRIPT_DIRECTORY to $HOME"
ln -s $SCRIPT_DIRECTORY/tmux.conf $HOME/.tmux.conf

echo "Linking vimrc from $SCRIPT_DIRECTORY to $HOME"
ln -s $SCRIPT_DIRECTORY/vimrc $HOME/.vimrc

echo "Linking vim from $SCRIPT_DIRECTORY to $HOME"
ln -s $SCRIPT_DIRECTORY/vim/ $HOME/.vim

echo "Removing sublime text 2 default config"
rm -r "$HOME/.config/sublime-text-2/Packages/User"

echo "Linking Sublime Text from $SCRIPT_DIRECTORY to $HOME"
ln -s $SCRIPT_DIRECTORY/sublime/User "$HOME/.config/sublime-text-2/Packages/User"
