# Completion for ssh/sftp/ssh-copy-id with config hostnames
_ssh() {
    local config=$HOME/.ssh/config
    local word=${COMP_WORDS[COMP_CWORD]}
    local -a hosts

    # Bail if the configuration file is illegible
    if [[ ! -r $config ]]; then
        return 1
    fi

    # Read hostnames from the file, no asterisks
    local option value
    while read -r option value _; do
        if [[ $option == Host && $value != *'*'* ]]; then
            hosts=("${hosts[@]}" "$value")
        fi
    done < "$config"

    # Generate completion reply
    COMPREPLY=( $(compgen -W "${hosts[*]}" -- "$word") )
}
complete -F _ssh ssh sftp ssh-copy-id

