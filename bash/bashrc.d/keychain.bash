# If GPG_TTY is set, update it
if [[ $GPG_TTY ]] ; then
    GPG_TTY=$(tty)
fi

