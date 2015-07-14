# Wrap scp(1) to check for missing colons
scp() {
    local argstring
    argstring=$*
    if (($# >= 2)) && [[ $argstring != *:* ]] ; then
        printf 'bash: %s: Missing colon, probably an error\n' \
            "$FUNCNAME" >&2
        return 2
    fi
    command scp "$@"
}

