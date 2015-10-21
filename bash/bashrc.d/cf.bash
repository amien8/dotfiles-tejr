# Count files
cf() {
    local dirname

    # Specify directory to check
    dirname=${1:-$PWD}

    # Error conditions
    if [[ ! -e $dirname ]] ; then
        printf 'bash: %s: %s does not exist\n' \
            "$FUNCNAME" "$dirname" >&2
        return 1
    elif [[ ! -d $dirname ]] ; then
        printf 'bash: %s: %s is not a directory\n' \
            "$FUNCNAME" "$dirname" >&2
        return 1
    elif [[ ! -r $dirname ]] ; then
        printf 'bash: %s: %s is not readable\n' \
            "$FUNCNAME" "$dirname" >&2
        return 1
    fi

    # Count files and print; use a subshell so options are unaffected
    (
        shopt -s dotglob nullglob
        declare -a files=("$dirname"/*)
        printf '%d\t%s\n' "${#files[@]}" "$dirname"
    )
}
complete -A directory cf

