# Completion for ftp with .netrc machines
_ftp() {

    # Do default completion if no results
    compopt -o default

    # Bail if the .netrc file is illegible
    local netrc
    netrc=$HOME/.netrc
    [[ -r $netrc ]] || return 1

    # Tokenize the file
    local -a tokens
    read -a tokens -d '' -r < "$netrc"

    # Iterate through tokens and collect machine names
    local -a machines
    local -i nxm
    local token
    for token in "${tokens[@]}" ; do
        if ((nxm)) ; then
            machines=("${machines[@]}" "$token")
            nxm=0
        elif [[ $token == machine ]] ; then
            nxm=1
        fi
    done

    # Generate completion reply
    local machine
    for machine in "${machines[@]}" ; do
        [[ $machine == "${COMP_WORDS[COMP_CWORD]}"* ]] || continue
        COMPREPLY=("${COMPREPLY[@]}" "$machine")
    done
}
complete -F _ftp ftp

