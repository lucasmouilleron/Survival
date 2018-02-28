#!/bin/bash

##############################################################
GHR="https://raw.githubusercontent.com/lucasmouilleron/Survival/master"
##############################################################
RED='\033[0;31m'
NC='\033[0m'

##############################################################
printStep() {
    echo "$RED$1$NC"
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
cd $HOME;curl -O -sL $GHR/configs/.zshrc
cd $HOME;curl -O -sL $GHR/configs/.vimrc
cd $HOME;curl -O -sL $GHR/configs/.selected_editor
cd $HOME;curl -O -sL $GHR/configs/.hushlogin

##############################################################
printStep "Done !"