# If interactive and rem(1) installed, run it
if [[ $- == *i* ]] && hash rem 2>/dev/null ; then (
    printf '\n'
    while read -r reminder ; do
        printf '* %s\n' "$reminder"
    done < <(rem -hq)
) ; fi

