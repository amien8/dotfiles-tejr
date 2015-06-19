# Unset all my *_COLORS vars when invoking make(1) if terminal doesn't have
# color; I have to do this because my wrapper functions are ignored by the
# /bin/sh fork make(1) does
make() {
    local -i colors
    colors=$( {
        tput Co || tput colors
    } 2>/dev/null )
    if ((colors >= 8)) ; then
        command make "$@"
    else
        (
            unset -v GCC_COLORS GREP_COLORS LS_COLORS
            command make "$@"
        )
    fi
}

# Completion setup for Make, completing targets
_make() {
    local word
    word=${COMP_WORDS[COMP_CWORD]}

    # Quietly bail if no legible Makefile
    if [[ ! -r Makefile ]] ; then
        return 1
    fi

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
    COMPREPLY=( $(compgen -W "${targets[*]}" -- "$word") )
}
complete -F _make -o default make

