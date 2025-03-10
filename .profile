
test -z "$PROFILEREAD" && . /etc/profile

 	

#. /usr/share/GNUstep/Makefiles/GNUstep.sh


# PS1='\[\033[1;32m\][\t]\[\033[38;5;202m\][\u@\h]\[\033[0;36m\]\w\$\[\033[0m\] '

#old PS1='\[\033[1;32m\][\t]\[\033[1;31m\][\u@\h]\[\033[0;36m\]\w\$\[\033[0m\] '



# Most applications support several languages for their output.
# To make use of this feature, simply uncomment one of the lines below or
# add your own one (see /usr/share/locale/locale.alias for more codes)
#
#export LANG=de_DE.UTF-8	# uncomment this line for German output
#export LANG=fr_FR.UTF-8	# uncomment this line for French output
#export LANG=es_ES.UTF-8	# uncomment this line for Spanish output





# Some people don't like fortune. If you uncomment the following lines,
# you will have a fortune each time you log in ;-)

if [ -x /usr/bin/fortune ] ; then
    echo
    /usr/bin/fortune
    echo
fi

if [ -x $HOME/.cargo/env ] ; then
. "$HOME/.cargo/env"
    fi

if [ -d "/opt/adb/platform-tools" ] ; then
 export PATH="/opt/adb/platform-tools:$PATH"
fi



export PATH="$HOME/.poetry/bin:$PATH"


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
