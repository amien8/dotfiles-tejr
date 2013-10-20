# If TTY/GPG_TTY are set, update them
if [[ $TTY || $GPG_TTY ]]; then
    TTY=$(tty)
    GPG_TTY=$TTY
fi

