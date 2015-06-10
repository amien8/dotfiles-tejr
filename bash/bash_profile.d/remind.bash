# If interactive, ~/.reminders, and rem(1), run it
if [[ $- == *i* ]] && \
   [[ -e $HOME/.reminders ]] && \
   hash rem 2>/dev/null ; then (
    while read -r reminder ; do
        printf '* %s\n' "$reminder"
    done < <(rem -hq)
    printf '\n'
) ; fi

