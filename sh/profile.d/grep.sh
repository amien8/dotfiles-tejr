# Store grep(1)'s --help output in a variable
grep_help=$(grep --help 2>/dev/null)

# Run dircolors(1) to export LS_COLORS if available and appropriate
case $grep_help in
    *--color*)
        GREP_COLORS='ms=01;31:mc=01;31:sl=:cx=:fn=35:ln=32:bn=32:se=36'
        export GREP_COLORS
        ;;
esac

# We're done parsing grep(1)'s --help output now
unset -v grep_help

