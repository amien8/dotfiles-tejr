# Shortcut to step up the directory tree with an arbitrary number of steps,
# like cd .., cd ../.., etc
ud() {

    # For completeness' sake, we'll pass any options to cd
    local arg
    local -a opts
    for arg ; do
        case $arg in
            --)
                shift
                break
                ;;
            -*)
                shift
                opts=("${opts[@]}" "$arg")
                ;;
            *)
                break
                ;;
        esac
    done

    # Check and save optional first argument, number of steps upward; default
    # to 1 if absent
    local -i steps
    steps=${1:-1}
    if ! ((steps > 0)) ; then
        printf 'bash: %s: Invalid step count %s\n' "$FUNCNAME" "$1" >&2
        return 2
    fi

    # Check and save optional second argument, target directory; default to
    # $PWD (typical usage case)
    local dirname
    dirname=${2:-$PWD}
    if [[ ! -e $dirname ]] ; then
        printf 'bash: %s: Target directory %s does not exist\n' "$FUNCNAME" "$2" >&2
        return 1
    fi

    # Append /.. to the target the specified number of times
    local -i i
    for (( i = 0 ; i < steps ; i++ )) ; do
        dirname=${dirname%/}/..
    done

    # Try to change into it
    cd "${opts[@]}" -- "$dirname"
}

# Completion setup for ud
_ud() {

    # The completions given are filenames and may require escaping
    compopt -o filenames

    # Only makes sense for the second argument
    ((COMP_CWORD == 2)) || return 1

    # Iterate through directories, null-separated, add them to completions
    local dirname
    while IFS= read -d '' -r dirname ; do
        [[ $dirname == "${COMP_WORDS[COMP_CWORD]}"* ]] || continue
        COMPREPLY=("${COMPREPLY[@]}" "$dirname")
    done < <(

        # Set options to glob correctly
        shopt -s dotglob nullglob

        # Collect directory names, strip trailing slashes
        local -a dirnames
        dirnames=(*/)
        dirnames=("${dirnames[@]%/}")

        # Bail if no results to prevent empty output
        ((${#dirnames[@]})) || exit 1

        # Print results null-delimited
        printf '%s\0' "${dirnames[@]}"
    )
}
complete -F _ud ud

