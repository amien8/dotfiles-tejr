# Run verse(1) if it's installed and we haven't seen it already today (the
# verses are selected by date); run in a subshell to keep vars out of global
# namespace
if command -v verse >/dev/null 2>&1 ; then (
    date=$(date +%Y-%m-%d)
    versefile=${VERSEFILE:-$HOME/.verse}
    if [ -e "$HOME"/.verse ] ; then
        read -r lastversedate < "$versefile"
    fi
    if [ "$date" \> "$lastversedate" ] ; then
        printf '\n%s\n\n' "$(verse)"
        printf '%s\n' "$date" > "$versefile"
    fi
) ; fi

