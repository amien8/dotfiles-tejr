# Store grep(1)'s --help output in a variable
grep_help=$(grep --help 2>/dev/null)

# Use GREP_OPTIONS to add some useful options to grep(1) calls if applicable
declare -a grep_options
if [[ $grep_help == *--binary-files* ]] ; then
    grep_options=("${grep_options[@]}" --binary-files=without-match)
fi
if [[ $grep_help == *--exclude* ]] ; then
    grep_options=("${grep_options[@]}" --exclude={.gitignore,.gitmodules})
fi
if [[ $grep_help == *--exclude-dir* ]] ; then
    grep_options=("${grep_options[@]}" --exclude-dir={.cvs,.git,.hg,.svn})
fi
GREP_OPTIONS=${grep_options[*]}
unset -v grep_options

# We're done parsing grep(1)'s --help output now
unset -v grep_help

# Define function wrapper for grep(1) with --color option if GREP_COLORS is
# set; checks that color is available in the terminal within the function
if [[ ! -n $GREP_COLORS ]] ; then
    return
fi

# Define function proper
grep() {
    local -i colors
    colors=$( {
        tput Co || tput colors
    } 2>/dev/null )
    if ((colors >= 8)) ; then
        command grep --color=auto "$@"
    else
        command grep "$@"
    fi
}

