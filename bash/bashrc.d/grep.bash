# Define function wrapper for grep(1) with --color option if GREP_COLORS is
# set; checks that color is available in the terminal within the function
if [[ ! -n $GREP_COLORS ]] ; then
    return
fi

# Define function proper
grep() {
    local -i colors=$( {
        tput Co || tput colors
    } 2>/dev/null )
    if ((colors >= 8)) ; then
        command grep --color=auto "$@"
    else
        command grep "$@"
    fi
}

