# Completion for ftp with .netrc machines
_ftp() {
    local netrc=$HOME/.netrc
    local word=${COMP_WORDS[COMP_CWORD]}
    local -a machines

    # Bail if the .netrc file is illegible
    if [[ ! -r $netrc ]]; then
        return 1
    fi

    # Tokenize the file
    local -a tokens
    IFS=$' \t\n' read -a tokens -d '' -r < "$netrc"

    # Iterate through tokens and collect machine names
    local machine=0
    for token in "${tokens[@]}"; do
        if ((machine)); then
            machines=("${machines[@]}" "$token")
            machine=0
        elif [[ $token == machine ]]; then
            machine=1
        fi
    done

    # Generate completion reply
    COMPREPLY=( $(compgen -W "${machines[*]}" -- "$word") )
}
complete -F _ftp ftp

