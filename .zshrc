# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=1000
unsetopt beep
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/mark/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

#this is your PROMPT
export PROMPT="%F{green}%n%f:%d >> "

#selected editor (for mc)
export EDITOR=/usr/bin/nvim

#ll
alias ll="ls -l"

#Install package grc
[[ -s "/etc/grc.zsh" ]] && source /etc/grc.zsh

#Zir arhivs
ex () {
 if [ -f $1 ] ; then
   case $1 in
     *.tar.bz2) tar xvjf $1   ;;
     *.tar.gz)  tar xvzf $1   ;;
     *.tar.xz)  tar xvfJ $1   ;;
     *.bz2)     bunzip2 $1    ;;
     *.rar)     unrar x $1    ;;
     *.gz)      gunzip $1     ;;
     *.tar)     tar xvf $1    ;;
     *.tbz2)    tar xvjf $1   ;;
     *.tgz)     tar xvzf $1   ;;
     *.zip)     unzip $1      ;;
     *.Z)       uncompress $1 ;;
     *.7z)      7z x $1       ;;
     *)         echo "'$1' не мб распакован при помощи >ex<" ;;
   esac
 else
   echo "'$1' не является допустимым файлом"
 fi
}
