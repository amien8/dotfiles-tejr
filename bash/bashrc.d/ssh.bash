# Completion for ssh/sftp/ssh-copy-id with config hostnames
_ssh() {

    # Use default completion if no matches
    compopt -o default

    # Read hostnames from existent config files, no asterisks
    local -a hosts
    local config option value
    for config in "$HOME"/.ssh/config /etc/ssh/ssh_config ; do
        [[ -e $config ]] || continue
        while read -r option value _ ; do
            [[ $option == Host ]] || continue
            [[ $value != *'*'* ]] || continue
            hosts=("${hosts[@]}" "$value")
        done < "$config"
    done

    # Generate completion reply
    for host in "${hosts[@]}" ; do
        [[ $host == "${COMP_WORDS[COMP_CWORD]}"* ]] || continue
        COMPREPLY=("${COMPREPLY[@]}" "$host")
    done
}
complete -F _ssh ssh sftp ssh-copy-id

