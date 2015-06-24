# Store whether we have colors in a variable
declare -i colors
colors=$( {
    tput Co || tput colors
} 2>/dev/null )

# Use LSOPTS to add some useful options to ls(1) calls if applicable; we use a
# function wrapper to do this
declare -a LSOPTS
if [[ -n $LS_COLORS ]] && ((colors >= 8)) ; then
    LSOPTS=("${LSOPTS[@]}" --color=auto)
fi

# Done, unset helper var
unset -v colors

# Define function proper
ls() {
    command ls "${LSOPTS[@]}" "$@"
}

