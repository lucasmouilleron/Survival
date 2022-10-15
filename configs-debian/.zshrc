#!/bin/zsh

###########################################################################
# ZSH
###########################################################################
export DISABLE_AUTO_UPDATE=true
export DISABLE_UPDATE_PROMPT=true
export ZSH_DISABLE_COMPFIX=true
export ZSH=$HOME/.oh-my-zsh
export SHELL=/usr/bin/zsh
plugins=(git sudo cp history themes ssh-agent zsh-syntax-highlighting)
ZSH_THEME="gianu"
source $ZSH/oh-my-zsh.sh

###########################################################################
# SSH AGENT
###########################################################################
zstyle :omz:plugins:ssh-agent identities id_rsa > /dev/null
zstyle :omz:plugins:ssh-agent lifetime 24h > /dev/null

###########################################################################
# PATH
###########################################################################
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/sbin:$PATH
export PATH=/usr/bin:$PATH
export PATH=/usr/sbin:$PATH

###########################################################################
# ALIASES
###########################################################################
alias 'ps?'='ps ax | grep -i'
alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -CF'
alias rm="rm -i"
alias m="micro"
alias zshconfig="m ~/.zshrc"
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color'
    #alias dir='dir --color'
    #alias vdir='vdir --color'
    alias grep='grep --color'
    alias fgrep='fgrep --color'
    alias egrep='egrep --color'
fi
tm() {tmux attach -t $1 || tmux new -s $1}
alias df="df -h"
dfd() {
    if [ ! -z "$1" ] ; then folder=$1 ; else folder="./" ; fi
    read -q "REPLY?Are you want to df deep for $folder ? <y/N> "
    if [[ $REPLY != "y" && $REPLY != "Y" ]] ; then return 1 ; fi
    echo "\n"
    sudo du -hs $folder/* | sort -hr
}

###########################################################################
# GIT
###########################################################################
alias git=git
alias gitm="git merge --no-ff"
alias gita="git add --all :/"
alias gitc="git commit -m"
alias gitac="gita && gitc"
alias gits="git status"
alias gitas="gita;gits"
alias gitp="git push"
alias gitf="git fetch"
alias gitpt="git remote | xargs -L1 git push --tags"
alias gitpa="git remote | xargs -L1 git push --all"
alias "gitt?"="git tag -l"
gitb() {
    branch="${1:?Provide a branch name}"
    if git show-ref --verify --quiet "refs/heads/$branch"; then
        echo >&2 "Branch '$branch' already exists."
        git checkout $1
    else
        echo >&2 "Branch '$branch' is created."
        git checkout -b $1
    fi
}
alias gitbl="git branch"
alias gitbd="git branch -d"
gitbda() {
    gitbd $1 && git remote | xargs -I % -L1 git push % --delete $1
}
gitacp() {
    if [ $# -ne 1 ]; then 
        echo "not enough params ! : gitacp "commit message""
        return
    fi
    gita
    gitc $1
    gitpa
}
alias gitpr="git pull-request"
mygittag() {git tag -a $1 -m $2}
alias gitt=mygittag

###########################################################################
# MISCS
###########################################################################
export VISUAL=micro
export EDITOR="$VISUAL"
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LANGUAGE=en_US:en
export DISPLAY=:0