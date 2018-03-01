#!/bin/bash

##############################################################
GHR="https://raw.githubusercontent.com/lucasmouilleron/Survival/master"
##############################################################
PYTHON_VERSION=3.5.1

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
printStep "Sudo ..."
read -p "What user has root rights and you know the password of (root*|username|skip) ? " answer
if [ "$answer" = "skip" ]; then
    printSmallStep "Skipping sudoing"
else
    if [ "$answer" = "" ]; then answer="root"; fi
    printSmallStep "Logging as $answer and making $USER sudoer"
    su - $answer -c "sudo usermod -aG sudo $USER"
    echo "$USER ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers
fi
##############################################################
printStep "SSH key ...";mkdir -p .ssh;ssh-keygen -b 2048 -t rsa -f $HOME/.ssh/id_rsa -q -N ""
##############################################################
printStep "Installing binaries ..."
sudo apt-get -qq update;sudo apt-get install -qq -y curl git zsh vim glances xclip openssl tmux
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
cd /usr/local/bin;curl -sS https://getmic.ro | sudo bash >/dev/null 2>&1;cd $HOME
##############################################################
printStep "Installing Python ..."
sudo apt-get install -y python3 python-pip python3-dev python-dev libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev
git clone git://github.com/yyuu/pyenv.git $HOME/.pyenv
git clone https://github.com/yyuu/pyenv-virtualenv.git $HOME/.pyenv/plugins/pyenv-virtualenv
CFLAGS=-I/usr/include/openssl LDFLAGS=-L/usr/lib $HOME/.pyenv/bin/pyenv install $PYTHON_VERSION
$HOME/.pyenv/bin/pyenv global $PYTHON_VERSION
##############################################################
printStep "Configuring locales ..."
sudo locale-gen --purge en_US.UTF-8;echo -e 'LANG="en_US.UTF-8"\nLANGUAGE="en_US:en"\n' | sudo tee /etc/default/locale
##############################################################
printStep "Configuring ..."
cd $HOME;getGHFile configs/.zshrc
cd $HOME;getGHFile configs/.vimrc
cd $HOME;getGHFile configs/.selected_editor
cd $HOME;getGHFile configs/.hushlogin
cd $HOME;getGHFile configs/.tmux.conf
##############################################################
printStep "Done !"