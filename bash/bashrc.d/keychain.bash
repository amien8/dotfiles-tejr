# If TTY/GPG_TTY are set, update them
if [[ $GPG_TTY ]] ; then
    GPG_TTY=$(tty)
fi

