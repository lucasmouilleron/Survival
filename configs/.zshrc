export ZSH=$HOME/.oh-my-zsh
plugins=(git sudo cp history themes zsh-syntax-highlighting)
ZSH_THEME="gianu"
source $ZSH/oh-my-zsh.sh

export VISUAL=vim
export EDITOR="$VISUAL"

alias 'ps?'='ps ax | grep -i'
alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -CF'
alias rm="rm -i"
alias sl="slap"
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi