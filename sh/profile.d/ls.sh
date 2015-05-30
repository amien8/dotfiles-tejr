# Store ls(1)'s --help output in a variable
lshelp=$(ls --help 2>/dev/null)

# Define and store appropriate colors for ls(1) if applicable
case $lshelp in
    *--color*)
        if command -v dircolors >/dev/null 2>&1 ; then
            if [ -r "$HOME"/.dircolors ] ; then
                eval "$(dircolors --sh -- "$HOME"/.dircolors)"
            else
                eval "$(dircolors --sh)"
            fi
        fi
        ;;
esac

# We're done parsing ls(1)'s --help output now
unset -v lshelp

