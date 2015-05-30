# Wrap scp to check for missing colons
scp() {
    local optstring=$*
    if (($# >= 2)) && [[ $optstring != *:* ]] ; then
        printf 'bash: %s: Missing colon, probably an error\n' \
            "$FUNCNAME" >&2
        return 2
    fi
    command scp "$@"
}

