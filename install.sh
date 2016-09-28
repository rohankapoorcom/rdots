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

IS_MAC=false

# Set path on MAC OS
if [ "$(uname -s)" == "Darwin" ]; then
  IS_MAC=true
  OLD_PATH=$PATH
  export PATH=$SCRIPT_DIRECTORY/bin:$PATH
fi

# Get the directory of the user
USER_HOME="$(getent passwd $SUDO_USER | cut -d: -f6)"

# Link up dot files
if ! [[ -L $USER_HOME/.tmux.conf ]]; then
  echo "Linking tmux.conf from $SCRIPT_DIRECTORY to $USER_HOME"
  sudo -u $USERNAME ln -s $SCRIPT_DIRECTORY/tmux.conf $USER_HOME/.tmux.conf
fi

if ! [[ -L $USER_HOME/.vimrc ]]; then
  echo "Linking vimrc from $SCRIPT_DIRECTORY to $USER_HOME"
  sudo -u $USERNAME ln -s $SCRIPT_DIRECTORY/vimrc $USER_HOME/.vimrc
fi

if ! [[ -L $USER_HOME/.vim && -d $USER_HOME/.vim ]]; then
  echo "Linking vim from $SCRIPT_DIRECTORY to $USER_HOME"
  sudo -u $USERNAME ln -s $SCRIPT_DIRECTORY/vim/ $USER_HOME/.vim
fi

# Clone Bash It
if ! [ "$(ls -A $SCRIPT_DIRECTORY/bash_it)" ]; then
  echo "Downloading latest copy of bash it to $SCRIPT_DIRECTORY/bash_it"
  sudo -u $USERNAME git submodule init
  sudo -u $USERNAME git submodule update
fi

# Install Bash It
if ! [[ -L $USER_HOME/.bash_it && -d $USER_HOME/.bash_it ]]; then
  echo "Linking bash_it from $SCRIPT_DIRECTORY to $USER_HOME"
  sudo -u $USERNAME ln -s $SCRIPT_DIRECTORY/bash_it $USER_HOME/.bash_it
fi

if ! [[ -L $USER_HOME/.bash_it/custom && -d $USER_HOME/.bash_it/custom ]]; then
  sudo -u $USERNAME rm -rf $USER_HOME/.bash_it/custom
  sudo -u $USERNAME ln -s $SCRIPT_DIRECTORY/bash-it-config $USER_HOME/.bash_it/custom
fi

# Add local bashrc to existing .bashrc
if ! grep -q "$SCRIPT_DIRECTORY/bashrc" "$USER_HOME/.bashrc"; then
  echo "Setting $SCRIPT_DIRECTORY/bashrc to be sourced by $USER_HOME/.bashrc"
  sudo -u $USERNAME echo "" >> "$USER_HOME/.bashrc"
  sudo -u $USERNAME echo "if [ -e \"$SCRIPT_DIRECTORY/bashrc\" ]; then" >> "$USER_HOME/.bashrc"
  sudo -u $USERNAME echo "  . \"$SCRIPT_DIRECTORY/bashrc\"" >> "$USER_HOME/.bashrc"
  sudo -u $USERNAME echo "fi" >> "$USER_HOME/.bashrc"
fi

# Mac OS X specific
if [ "$IS_MAC" = true ]; then
  # Unset path on MAC OS
  export PATH=$OLD_PATH
  FONTS_DIR="$USER_HOME/Library/Fonts"
fi

# Ubuntu specific installations (sublime text 3, spotify, Logitech t650 control script)
if [[ "$IS_MAC" = false && "$(lsb_release -si)" == "Ubuntu" ]]; then
  # Check for graphical environment
  if ! tty -s; then
    if ! [ "$(dpkg -s sublime-text-installer | grep Status)" == "Status: install ok installed" ]; then
      echo "Installing Sublime Text 3"
      add-apt-repository -y ppa:webupd8team/sublime-text-3
      apt-get update
      apt-get install sublime-text-installer

      echo "Removing Sublime Text 3 default config"
      sudo -u $USERNAME rm -r "$USER_HOME/.config/sublime-text-3/Packages/User"
      sudo -u $USERNAME mkdir -p "$USER_HOME/.config/sublime-text-2/Packages/"

      echo "Linking Sublime Text from $SCRIPT_DIRECTORY to $USER_HOME"
      sudo -u $USERNAME ln -s $SCRIPT_DIRECTORY/sublime-3/User "$USER_HOME/.config/sublime-text-3/Packages/User"
    fi

    if ! [ "$(dpkg -s spotify-client | grep Status)" == "Status: install ok installed" ]; then
      apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886
      echo deb http://repository.spotify.com stable non-free | tee /etc/apt/sources.list.d/spotify.list
      apt-get update
      apt-get install spotify-client
    fi

    echo "Copying touchsettings.sh from $SCRIPT_DIRECTORY to /etc/profile.d/"
    cp $SCRIPT_DIRECTORY/touchsettings.sh /etc/profile.d/touchsettings.sh
  fi
  FONTS_DIR="$USER_HOME/.fonts"
fi

# Install Fonts
sudo -u $USERNAME mkdir -p $FONTS_DIR
if ! [[ -L $FONTS_DIR/custom && -d $FONTS_DIR/custom ]]; then
  echo "Linking fonts/OTF from $SCRIPT_DIRECTORY to $USER_HOME"
  sudo -u $USERNAME ln -s $SCRIPT_DIRECTORY/fonts/OTF $FONTS_DIR/custom
  if [ "$IS_MAC" = false ]; then
    fc-cache -fv
  fi
fi
