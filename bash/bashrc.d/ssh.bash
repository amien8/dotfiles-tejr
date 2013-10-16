# Bail if no ssh(1)
if ! hash ssh 2>/dev/null; then
    return
fi

# Completion for ssh/sftp/ssh-copy-id with config hostnames
_ssh() {
    local word=${COMP_WORDS[COMP_CWORD]}

    # Bail if the configuration file is illegible
    local config=$HOME/.ssh/config
    if [[ ! -r $config ]]; then
        COMPREPLY=()
        return 1
    fi

    # Read hostnames from the file, no asterisks
    local -a hosts
    local option value
    while read -r option value _; do
        if [[ $option == Host && $value != *'*'* ]]; then
            hosts=("${hosts[@]}" "$value")
        fi
    done < "$config"

    # Generate completion reply
    COMPREPLY=( $(compgen -W "${hosts[*]}" -- "$word") )
}
complete -F _ssh -o default ssh sftp ssh-copy-id

