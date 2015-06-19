# Define function wrapper for gcc(1) with --color option if GCC_COLORS is set;
# checks that color is available in the terminal within the function
if [[ ! -n $GCC_COLORS ]] ; then
    return
fi

# Define function proper
gcc() {
    local -i colors
    colors=$( {
        tput Co || tput colors
    } 2>/dev/null )
    if ((colors >= 8)) ; then
        command gcc --color=auto "$@"
    else
        command gcc "$@"
    fi
}

