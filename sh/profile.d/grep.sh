# Store grep(1)'s --help output in a variable
grep_help=$(grep --help 2>/dev/null)

# Define and store appropriate colors for grep(1) if applicable
case $grep_help in
    *--color*)
        GREP_COLORS='ms=01;31:mc=01;31:sl=:cx=:fn=35:ln=32:bn=32:se=36'
        export GREP_COLORS
        ;;
esac

# Use GREP_OPTIONS to add some useful --exclude and --exclude-dir options to
# grep(1) calls if applicable
case $grep_help in
    *--exclude*)
        for exclude in .gitignore .gitmodules ; do
            GREP_OPTIONS=${GREP_OPTIONS:+$GREP_OPTIONS }'--exclude='$exclude
        done
        unset -v exclude
        ;;
esac
case $grep_help in
    *--exclude-dir*)
        for exclude_dir in .cvs .git .hg .svn ; do
            GREP_OPTIONS=${GREP_OPTIONS:+$GREP_OPTIONS }'--exclude-dir='$exclude_dir
        done
        unset -v exclude_dir
        ;;
esac

# We're done parsing grep(1)'s --help output now
unset -v grep_help

# Export the grep(1) options if we decided on any
if [ -n "$GREP_OPTIONS" ] ; then
    export GREP_OPTIONS
fi

