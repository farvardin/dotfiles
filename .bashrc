## Farvardin's .bashrc
## 2024-12

source /etc/profile
source ~/.profile

# don't load xrdb, it will messed up remote connections
# use .Xresources instead, it should be loaded by the WM
# xrdb -load ~/.Xdefaults
# xrdb -load ~/.Xresources
# [[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

if [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi


alias ..="cd .."
alias which="type -path"
alias where="type -all"

alias rm="rm -i" # mode interactif
alias mv="mv -i"
alias cp="cp -i"
alias psg='ps auxww | grep'

alias rmfirefoxcache='rm -fr /home/eric/.cache/mozilla/firefox/zv7szrpx.default-1697456657405/cache2/entries/* & printf "/home/eric/.cache/mozilla/firefox/zv7szrpx.default-1697456657405/cache2/entries/" '


OS="`uname`"
case $OS in
'Linux')
	alias ll="ls -l --color=auto"  
	alias l="ls -a --color=auto"
	alias la="ls -la --color=auto"
	alias ls="ls --color=auto"
	;;
*'BSD')
        # pkgin install colorls
	export LSCOLORS='6x5x2x3x1x464301060203'
	alias ls="/usr/pkg/bin/colorls -FG"   # -G à la place de --color=auto sur BSD
	alias ll="ls -l"
	alias l="ls -a "
	alias la="ls -la "	
	;;
esac





alias trouve0="find ./ -type f | xargs grep -l "
alias cherche-et-trouve="find  / -maxdepth 50 -type f | xargs grep -l "
alias cherche-ici="find ./ -depth -maxdepth 20 -iname "
alias cherche-partout="find / -depth -maxdepth 50 -iname "
alias android="/opt/adt-bundle-linux-x86_64-20131030/sdk/tools/android"
# alias renpy="/opt/renpy/renpy.sh"
alias genymotion=" /media/eric/sauvegardes/genymotion_android/genymotion/genymotion"
alias frotzu="luit -encoding iso-8859-1 frotz -d -l 3 -r 3"
alias killflash="killall plugin-container"
alias killsaver="killall klorenz.kss"
alias kill9="kill -9"
alias locateall="locate -iA"
alias openall="xdg-open"
alias xopen="xdg-open"
alias todo='todo.sh -d ~/_mesdocs/mes_vcs/dotfiles/todo.cfg'
alias xterm="xterm -font -*-fixed-medium-r-*-*-20-*-*-*-*-*-*-* -geometry 70x24"

alias xjed="xjed -fn mono -fs 16"

alias scite="SciTE"

alias kubectl=microk8s.kubectl

alias uf-glossary="scite ~/ownCloud/en_cours/uxn/uf_forth/uf8/GLOSSARY"

# alias android-connect="mtpfs -o allow_other /mnt/nexus"
# alias android-disconnect="fusermount -u /mnt/nexus"


## ALIASES
alias ufx="uxnemu -2x ~/roms/ufx.rom" 
alias uf="uxncli ~/roms/uf.rom" 
alias picotron='/home/eric/ownCloud/en_cours/picotron/picotron'
alias hp48g='/home/eric/ownCloud/divers/opt/hp48/x48ng'
alias lagrange='/opt/Lagrange-1.18.1-x86_64.AppImage'
alias lisp='sbcl'
alias portacle='/opt/lisp-portacle/lin/bin/portacle'
alias runabc='/opt/runabc/runabc.tcl'

# https://github.com/nvbn/thefuck
if [ -f /usr/bin/thefuck ] || [ -f /usr/local/bin/thefuck ]; then
    eval $(thefuck --alias)
    alias zut="fuck"
fi



alias_help()
{
  f=~/.bashrc
  my_aliases=$(egrep '^\s*alias\s+.+=' ${f}|sed -r 's/\s*alias\s+(.+)=\".+\"(\s*#\s*(.+))?/\1: \3;/')
  echo $my_aliases|tr ';' '\n'
}



#bind '"²":menu-complete'



export  PATH=$PATH:/usr/NX/bin/:/usr/local/lib/:/usr/local/include/:/usr/local/bin:/home/eric/.local/share/Steam/ubuntu12_32/steam-runtime/i386/usr/lib/i386-linux-gnu/:/opt/utroff/bin/:$HOME/.local/bin/:$HOME/_mesdocs/mes_scripts/:$HOME/ownCloud/divers/opt/:/opt/:/usr/local/Gambit/bin/:$HOME/.local/share/yabridge/

export GS_LIB=/home/eric/_mesdocs/mes_musiques/abc/site/fonts/
#export JAVA_HOME=/opt/java/jre/bin/java


export GOPATH=$HOME/gopath

export  PATH=$PATH:/usr/local/lib/:/opt/gnome/bin/:/usr/NX/bin/:/usr/bin/android-sdk-linux/platform-tools:/usr/include/wx-2.8/wx/:/home/eric/.local/share/Steam/ubuntu12_32/steam-runtime/i386/usr/lib/i386-linux-gnu/:$GOPATH:$GOPATH/bin:/opt/nim-1.4.0/bin/


export PATH=$PATH:/usr/local/go/bin


export SVN_EDITOR=vim
export EDITOR="gvim -f"
export SH=/bin/bash



# colors, see https://unix.stackexchange.com/questions/124407/what-color-codes-can-i-use-in-my-bash-ps1-prompt

case ${HOSTNAME} in
	'saraswati')
	    PS1='\[\033[1;32m\][\t]\[\033[38;5;202m\][\u@\h]\[\033[0;36m\]\w\$\[\033[0m\] '
		;;
	'belisama')
	    PS1='\[\033[1;32m\][\t]\[\033[38;5;1m\][\u@\h]\[\033[0;36m\]\w\$\[\033[0m\] '
		;;
	*)
	    PS1='\[\033[1;32m\][\t]\[\033[38;5;129m\][\u@\h]\[\033[0;36m\]\w\$\[\033[0m\] '
		;;
esac

#export TERM=xterm-256color-italic
# source "$HOME/.cargo/env"
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

[ -f "/home/eric/.ghcup/env" ] && source "/home/eric/.ghcup/env" # ghcup-env
export PATH=/temp/github/gcsplit/bin/Debug:$PATH
export PATH=/temp/github/gcsplit/SPAdes-3.11.1-Linux/bin:$PATH
export PATH=/temp/github/gcsplit/KmerStream:$PATH


export QT_QPA_PLATFORMTHEME=qt5ct
# pb with some apps
# export QT_SCALE_FACTOR=1.2
export QT_SCALE_FACTOR=1
export QT_SCALE_FACTOR_ROUNDING_POLICY=Round
export QT_AUTO_SCREEN_SCALE_FACTOR=1
export QT_DEVICE_PIXEL_RATIO=1


####### debian stuffs

# append to the history file, don't overwrite it
shopt -s histappend

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# . /home/eric/.asdf/asdf.sh
# . /home/eric/.asdf/completions/asdf.bash

# disable ctrl+S for halting the terminal
stty -ixon



export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH=$BUN_INSTALL/bin:$PATH


# >>> juliaup initialize >>>


# !! Contents within this block are managed by juliaup !!

case ":$PATH:" in
    *:/home/eric/.juliaup/bin:*)
        ;;

    *)
        export PATH=/home/eric/.juliaup/bin${PATH:+:${PATH}}
        ;;
esac

# <<< juliaup initialize <<<

# . "$HOME/.cargo/env"
