# Bail if no make(1)
if ! hash make 2>/dev/null ; then
    return
fi

# Completion setup for Make, completing targets
#
# Note that because of the 
_make() {
    local word=${COMP_WORDS[COMP_CWORD]}

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

