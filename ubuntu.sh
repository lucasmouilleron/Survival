#!/bin/bash

ghr="https://raw.githubusercontent.com/lucasmouilleron/Survival/master"

sudo apt-get install -y curl git zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
curl  -O -L $ghr/configs/.zshrc
curl  -O -L $ghr/configs/.vimrc
curl  -O -L $ghr/configs/.hushlogin