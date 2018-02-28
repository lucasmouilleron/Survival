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
printStep "Updating ..."
sudo apt-get -qq update

##############################################################
printStep "Installing binaries ..."
sudo apt-get install -qq -y curl git zsh vim glances

##############################################################
printStep "Running install ..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

##############################################################
printStep "Configuring ..."
curl  -O -sL $GHR/configs/.zshrc
curl  -O -sL $GHR/configs/.vimrc
curl  -O -sL $GHR/configs/.hushlogin

##############################################################
printStep "Done !"