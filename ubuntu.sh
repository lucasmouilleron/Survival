#!/bin/bash

##############################################################
GHR="https://raw.githubusercontent.com/lucasmouilleron/Survival/master"
##############################################################
RED='\033[0;31m'
GREEN='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

##############################################################
printStep() {
    echo "$GREEN$1$NC"
}

##############################################################
printError() {
    echo "$RED$1$NC"
}

##############################################################
printSmallStep() {
    echo "$BLUE$1$NC"
}

##############################################################
getGHFile() {
    printSmallStep "Downloading file $GHR/$1"
    curl -O -sL --fail $GHR/$1
    returnCode=$?
    if [ "$returnCode" -ne "0" ]; then
        printError "Can't download file $GHR/$1 $returnCode"
    fi
}

##############################################################
printStep "Sudo ...";sudo usermod -aG sudo $USER;echo "$USER ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers
printStep "SSH key ...";mkdir -p .ssh;ssh-keygen -b 2048 -t rsa -f $HOME/.ssh/id_rsa -q -N ""

##############################################################
printStep "Installing binaries ..."
sudo apt-get -qq update;sudo apt-get install -qq -y curl git zsh vim glances
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

##############################################################
printStep "Configuring ..."
cd $HOME;getGHFile configs/.zshrc
cd $HOME;getGHFile configs/.vimrc
cd $HOME;getGHFile configs/.selected_editor
cd $HOME;getGHFile configs/.hushlogin

##############################################################
printStep "Done !"