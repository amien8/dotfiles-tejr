# Wrapper around gpg(1) to stop ``--batch'' breaking things
gpg() {
    case $* in
        *--ed*|*--gen-k*|*--sign-k*)
            command gpg --no-batch "$@"
            ;;
        *)
            command gpg "$@"
            ;;
    esac
}

# Completion for gpg with long options
_gpg() {
    local word=${COMP_WORDS[COMP_CWORD]}

    # Bail if no gpg(1)
    if ! hash gpg 2>/dev/null ; then
        return 1
    fi

    # Bail if word doesn't start with two dashes
    if [[ $word != --* ]] ; then
        return 1
    fi

    # Generate completion reply
    COMPREPLY=( $(compgen -W \
        "$(gpg --dump-options 2>/dev/null)" \
        -- "$word") )
}
complete -F _gpg -o default gpg

