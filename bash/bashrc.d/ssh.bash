# Wrap scp to check for missing colons
scp() {
    if (($# >= 2)) && [[ $* != *:* ]] ; then
        printf 'scp: Missing colon, probably an error\n' >&2
        return 1
    fi
    command scp "$@"
}

# Completion for ssh/sftp/ssh-copy-id with config hostnames
_ssh() {
    local word=${COMP_WORDS[COMP_CWORD]}

    # Read hostnames from existent config files, no asterisks
    local -a hosts
    local config option value
    for config in "$HOME"/.ssh/config /etc/ssh/ssh_config ; do
        if [[ -e $config ]] ; then
            while read -r option value _ ; do
                if [[ $option == Host && $value != *'*'* ]] ; then
                    hosts=("${hosts[@]}" "$value")
                fi
            done < "$config"
        fi
    done

    # Generate completion reply
    COMPREPLY=( $(compgen -W "${hosts[*]}" -- "$word") )
}
complete -F _ssh -o default ssh sftp ssh-copy-id

