# Completion for ftp with .netrc machines
_ftp() {
    local word
    word=${COMP_WORDS[COMP_CWORD]}

    # Bail if the .netrc file is illegible
    local netrc
    netrc=$HOME/.netrc
    if [[ ! -r $netrc ]] ; then
        return 1
    fi

    # Tokenize the file
    local -a tokens
    read -a tokens -d '' -r < "$netrc"

    # Iterate through tokens and collect machine names
    local -a machines
    local -i machine
    local token
    for token in "${tokens[@]}" ; do
        if ((machine)) ; then
            machines=("${machines[@]}" "$token")
            machine=0
        elif [[ $token == machine ]] ; then
            machine=1
        fi
    done

    # Generate completion reply
    COMPREPLY=( $(compgen -W "${machines[*]}" -- "$word") )
}
complete -F _ftp -o default ftp

