#!/bin/bash

##############################################################
# CONFIG
##############################################################
GHR="https://raw.githubusercontent.com/lucasmouilleron/Survival/master"
##############################################################
# HELPERS
##############################################################
RED='\033[0;31m';GREEN='\033[0;33m';BLUE='\033[0;34m';NC='\033[0m'
printStep() { echo "$GREEN$1$NC"; }
printError() { echo "$RED$1$NC"; }
printSmallStep() { echo "$BLUE$1$NC"; }
##############################################################
getGHConfigFile() {
    printSmallStep "Downloading file $GHR/configs/$1"
    if [ -f $1 ]; then cp $1 $1.back.$(date +%s); fi
    curl -O -sL --fail $GHR/configs/$1
    returnCode=$?
    if [ "$returnCode" -ne "0" ]; then
        printError "Can't download file $GHR/configs/$1 $returnCode"
    fi
}

##############################################################
# MAIN
##############################################################
sudo -n true
if [ "$?" != "0" ]; then echo "You must be a sudoer to run this script. Log as a sudoer user and run 'sudo usermod -aG sudo $USER'"; exit 1; fi
printStep "Sudo ..."
echo "$USER ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers
##############################################################
printStep "SSH key ...";mkdir -p .ssh;ssh-keygen -b 2048 -t rsa -f $HOME/.ssh/id_rsa -q -N ""
##############################################################
printStep "Installing binaries ..."
sudo apt-get -qq update;sudo apt-get install -qq -y curl git zsh vim glances xclip openssl tmux ca-certificates # main binaries
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" # oh my zsh
echo "ok"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/loket/oh-my-zsh/feature/batch-mode/tools/install.sh)" -s --batch
cd /usr/local/bin;curl -sS https://getmic.ro | sudo bash >/dev/null 2>&1;cd $HOME # micro
##############################################################
printStep "Configuring locales ..."
sudo locale-gen --purge en_US.UTF-8;echo -e 'LANG="en_US.UTF-8"\nLANGUAGE="en_US:en"\n' | sudo tee /etc/default/locale
##############################################################
printStep "Configuring ..."
cd $HOME;getGHConfigFile .zshrc
cd $HOME;getGHConfigFile .vimrc
cd $HOME;getGHConfigFile .selected_editor
cd $HOME;getGHConfigFile .hushlogin
cd $HOME;getGHConfigFile .tmux.conf

##############################################################
printStep "Done !"