# Completion setup for Make, completing targets
_make() {

    # Do default completion if no matches
    compopt -o default

    # Bail if no legible Makefile
    [[ ! -r Makefile ]] || return 1

    # Build a list of targets by parsing the Makefile
    local -a targets tokens
    local target line
    while read -r line ; do
        if [[ $line == *:* ]] ; then
            target=$line
            target=${target%%:*}
            target=${target% }
            if [[ $target != *[^[:alnum:][:space:]_-]* ]] ; then
                IFS=' ' read -a tokens \
                    < <(printf '%s\n' "$target")
                targets=("${targets[@]}" "${tokens[@]}")
            fi
        fi
    done < Makefile

    # Complete with matching targets
    for target in "${targets[@]}" ; do
        [[ $target == "${COMP_WORDS[COMP_CWORD]}"* ]] || continue
        COMPREPLY=("${COMPREPLY[@]}" "$target")
    done
}
complete -F _make make

