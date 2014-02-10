# Bail if no ftp(1)
if ! hash ftp 2>/dev/null ; then
    return
fi

# Completion for ftp with .netrc machines
_ftp() {
    local word=${COMP_WORDS[COMP_CWORD]}

    # Bail if the .netrc file is illegible
    local netrc=$HOME/.netrc
    if [[ ! -r $netrc ]] ; then
        COMPREPLY=()
        return 1
    fi

    # Tokenize the file
    local -a tokens
    IFS=$' \t\n' read -a tokens -d '' -r < "$netrc"

    # Iterate through tokens and collect machine names
    local -a machines
    local token machine
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

