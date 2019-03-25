#!/bin/bash

##############################################################
# CONFIG
##############################################################
VERSION="1.3"
GHR="https://raw.githubusercontent.com/lucasmouilleron/Survival/master"
DISTRIB_CONFIG_FOLDER="configs-debian"

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
sudo apt-get -qq update;sudo apt-get install -qq -y curl git zsh vim glances xclip openssl tmux ca-certificates ssh net-tools
if [ -d $HOME/.oh-my-zsh ]; then rm -rf $HOME/.oh-my-zsh; fi;git clone --quiet --depth=1 https://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh
cd $HOME/.oh-my-zsh/plugins;git clone --quiet https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
cd /usr/local/bin;curl -sS https://getmic.ro | sudo bash >/dev/null 2>&1;cd $HOME # micro
##############################################################
printStep "Configuring locales ...";sudo locale-gen --purge en_US.UTF-8;echo -e 'LANG="en_US.UTF-8"\nLANGUAGE="en_US:en"\n' | sudo tee /etc/default/locale
##############################################################
printStep "Configuring ...";
cd $HOME;getGHConfigFileWB .zshrc;getGHConfigFileWB .vimrc;getGHConfigFile .selected_editor;getGHConfigFile .hushlogin;getGHConfigFileWB .tmux.conf;getGHConfigFileWB .config/micro/settings.json;getGHConfigFileWB .config/micro/bindings.json
##############################################################
printStep "Last step, switching shell. After it's done, delog and relog.";chsh -s $(which zsh)