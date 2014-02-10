# Define and store appropriate colors for ls
if command -v dircolors >/dev/null 2>&1 ; then
    eval "$(dircolors --sh)"
fi

