# Define function wrapper for ls(1) with --color option if LS_COLORS is set;
# checks that color is available in the terminal within the function
if [[ $LS_COLORS ]] ; then
    ls() {
        local -i colors=$(tput colors 2>/dev/null)
        if ((colors >= 8)) ; then
            command ls --color=auto "$@"
        else
            command ls "$@"
        fi
    }
fi

