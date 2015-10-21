# Wrapper around gpg(1) to stop ``--batch'' breaking things
gpg() {
    local argstring
    argstring=$*
    case $argstring in
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

    # Complete with directories/files if no matches
    compopt -o default

    # Bail if no gpg(1)
    hash gpg 2>/dev/null || return 1

    # Bail if not completing an option
    [[ ${COMP_WORDS[COMP_CWORD]} == --* ]] || return 1

    # Generate completion reply from gpg(1) options
    local option
    while read -r option ; do
        [[ $option == "${COMP_WORDS[COMP_CWORD]}"* ]] || continue
        COMPREPLY=("${COMPREPLY[@]}" "$option")
    done < <(gpg --dump-options 2>/dev/null)
}
complete -F _gpg gpg

