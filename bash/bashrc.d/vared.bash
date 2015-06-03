# Requires Bash >= 4.0 for read -i and ${!name}
if ((10#${BASH_VERSINFO[0]%%[![:digit:]]*} < 4)) ; then
    return
fi

# Edit named variables' values
vared() {
    if ! (($#)) ; then
        printf 'bash: %s: No variable names given\n' \
            "$FUNCNAME" >&2
        return 2
    fi
    local name
    for name in "$@" ; do
        IFS= read -e -i "${!name}" -p "$name"= -r "$name"
    done
}
complete -A variable vared

