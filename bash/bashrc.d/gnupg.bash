# Bail if no gpg(1)
if ! hash gpg 2>/dev/null; then
    return
fi

# Wrapper around gpg(1) to stop ``--batch'' breaking things
gpg() {
    case $* in
        *--ed*|*--sign-k*)
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

    # Bail if word doesn't start with two dashes
    if [[ $word != --* ]]; then
        COMPREPLY=()
        return 1
    fi

    # Read options from the output of gpg --dump-options
    local -a options
    local option
    while read -r option; do
        options=("${options[@]}" "$option")
    done < <(gpg --dump-options 2>/dev/null)

    # Generate completion reply
    COMPREPLY=( $(compgen -W "${options[*]}" -- "$word") )
}
complete -F _gpg -o default gpg

