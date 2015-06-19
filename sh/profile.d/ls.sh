# Store ls(1)'s --help output in a variable
ls_help=$(ls --help 2>/dev/null)

# Run dircolors(1) to export LS_COLORS if available and appropriate
case $ls_help in
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
unset -v ls_help

