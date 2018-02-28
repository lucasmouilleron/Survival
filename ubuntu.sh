#!/bin/bash

ghr="https://raw.githubusercontent.com/lucasmouilleron/Survival/master"

echo "Updating ..."
sudo apt-get -qq update

echo "Installing binaries ..."
sudo apt-get install -qq -y curl git zsh vim glances

echo "Running install ..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

echo "Configuring ..."
curl  -O -sL $ghr/configs/.zshrc
curl  -O -sL $ghr/configs/.vimrc
curl  -O -sL $ghr/configs/.hushlogin