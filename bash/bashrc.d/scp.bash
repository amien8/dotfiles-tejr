# Wrap scp to check for missing colons
scp() {
    if (($# >= 2)) && [[ $* != *:* ]] ; then
        printf 'scp: Missing colon, probably an error\n' >&2
        return 1
    fi
    command scp "$@"
}

