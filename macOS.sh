#!/bin/bash

##############################################################
# CONFIG
##############################################################
VERSION="1.3"
GHR="https://raw.githubusercontent.com/lucasmouilleron/Survival/master"
DISTRIB_CONFIG_FOLDER="configs-macOS"

##############################################################
# HELPERS
##############################################################
RED='\033[0;31m';GREEN='\033[0;33m';BLUE='\033[0;34m';NC='\033[0m'
printStep() { echo "$GREEN$1$NC"; }
printDanger() { echo "$RED$1$NC"; }
printSmallStep() { echo "$BLUE$1$NC"; }
##############################################################
getGHConfigFile() {
    CONFIG_FILE=$1
    printSmallStep "Downloading file $GHR/$DISTRIB_CONFIG_FOLDER/$CONFIG_FILE"
    curl --create-dirs -o $CONFIG_FILE -sL --fail $GHR/$DISTRIB_CONFIG_FOLDER/$CONFIG_FILE
    if [ "$?" -ne "0" ]; then printDanger "Can't download file $GHR/$DISTRIB_CONFIG_FOLDER/$CONFIG_FILE $returnCode"; fi
}
##############################################################
getGHConfigFileWB() {
    CONFIG_FILE=$1
    if [ -f $1 ]; then cp $CONFIG_FILE $CONFIG_FILE.back; fi
    getGHConfigFile $CONFIG_FILE
}

##############################################################
# TEST SUDOER
##############################################################
sudo -n true;if [ "$?" != "0" ]; then echo "You must be a sudoer to run this script. Log as a sudoer user and run 'sudo usermod -aG sudo $USER', switch back to $USER, run 'sudo ls' to make sure it works, and run again"; exit 1; fi

##############################################################
# MAIN
##############################################################
printDanger "Survival Installer $VERSION"
printStep "Sudo without prompt ...";echo "$USER ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers
##############################################################
printStep "SSH key ...";mkdir -p .ssh;ssh-keygen -b 2048 -t rsa -f $HOME/.ssh/id_rsa -q -N "$SSH_PASSPHRASE"
##############################################################
printStep "Installing binaries ..."
 # homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
# utils
brew update;brew install git glances tmux micro ncdu btop
 # contexts
brew cask install contexts
 # hammerspoon
brew cask install hammerspoon
 # visidata
brew install saulpw/vd/visidata
 # zsh
if [ -d $HOME/.oh-my-zsh ]; then rm -rf $HOME/.oh-my-zsh; fi;git clone --quiet --depth=1 https://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh
 # zsh plugins
cd $HOME/.oh-my-zsh/plugins;git clone --quiet https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
##############################################################
printStep "Configuring ...";
cd $HOME;getGHConfigFileWB .zshrc;getGHConfigFileWB .vimrc;getGHConfigFileWB .tmux.conf;getGHConfigFileWB .config/micro/settings.json;getGHConfigFileWB .config/micro/bindings.json;getGHConfigFileWB .hammerspoon/init.lua;getGHConfigFileWB .config/btop/btop.conf
printStep "From Hammerspoon Preferences, check 'Open at login', uncheck 'Show dock icon'";open -a Hammerspoon
printStep "From Contexts Preferences, check 'Welcome > Lauch Contexts at login', uncheck 'Sidebar > No display, create an item in 'Command tab' for key 'cmd+@' and for active apps";open -a Contexts
##############################################################
printStep "Last step, switching shell ...";chsh -s $(grep /zsh$ /etc/shells | tail -1);env zsh -l