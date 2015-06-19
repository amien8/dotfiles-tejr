if command -v dircolors >/dev/null 2>&1 ; then
    if [ -r "$HOME"/.dircolors ] ; then
        eval "$(dircolors --sh -- "$HOME"/.dircolors)"
    else
        eval "$(dircolors --sh)"
    fi
fi

