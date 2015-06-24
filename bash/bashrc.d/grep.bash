# Store whether we have colors in a variable
declare -i colors
colors=$( {
    tput Co || tput colors
} 2>/dev/null )

# Store grep(1)'s --help output in a variable
grep_help=$(grep --help 2>/dev/null)

# Use GREPOPTS to add some useful options to grep(1) calls if applicable; we
# use a function wrapper to do this, rather than GREP_OPTIONS as we don't want
# to change grep(1)'s actual behaviour inside scripts
declare -a GREPOPTS
if [[ -n $GREP_COLORS ]] && ((colors >= 8)) ; then
    GREPOPTS=("${GREPOPTS[@]}" --color=auto)
fi
if [[ $grep_help == *--binary-files* ]] ; then
    GREPOPTS=("${GREPOPTS[@]}" --binary-files=without-match)
fi
if [[ $grep_help == *--exclude* ]] ; then
    GREPOPTS=("${GREPOPTS[@]}" --exclude={.gitignore,.gitmodules})
fi
if [[ $grep_help == *--exclude-dir* ]] ; then
    GREPOPTS=("${GREPOPTS[@]}" --exclude-dir={.cvs,.git,.hg,.svn})
fi

# Done, unset helper vars
unset -v grep_help colors

# Define function proper
grep() {
    command grep "${GREPOPTS[@]}" "$@"
}

