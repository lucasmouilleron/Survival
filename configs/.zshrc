#!/bin/zsh

###########################################################################
# ZSH
###########################################################################
export ZSH=$HOME/.oh-my-zsh
plugins=(git sudo cp history themes zsh-syntax-highlighting)
ZSH_THEME="gianu"
source $ZSH/oh-my-zsh.sh

###########################################################################
# ALIASES
###########################################################################
alias 'ps?'='ps ax | grep -i'
alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -CF'
alias rm="rm -i"
alias mc="micro"
alias zshconfig="mc ~/.zshrc"
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi
tm() {tmux attach -t $1 || tmux new -s $1}

###########################################################################
# MISCS
###########################################################################
export VISUAL=vim
export EDITOR="$VISUAL"
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LANGUAGE=en_US:en
