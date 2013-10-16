# If TTY/GPG_TTY are set, update them
if [[ -n $TTY || -n $GPG_TTY ]]; then
    TTY=$(tty)
    GPG_TTY=$TTY
fi

