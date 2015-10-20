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
    local dir
    dir=${2:-$PWD}
    if [[ ! -e $dir ]] ; then
        printf 'bash: %s: Target dir %s does not exist\n' "$FUNCNAME" "$2" >&2
        return 1
    fi

    # Append /.. to the target the specified number of times
    local -i i
    for (( i = 0 ; i < steps ; i++ )) ; do
        dir=${dir%/}/..
    done

    # Try to change into it
    cd "${opts[@]}" -- "$dir"
}

# Completion is only useful for the second argument
_ud() {
    if ((COMP_CWORD == 2)) ; then
        local word
        word=${COMP_WORDS[COMP_CWORD]}
        compopt -o filenames
        local IFS=$'\n'
        COMPREPLY=( $(compgen -A directory -- "$word" ) )
    else
        return 1
    fi
}
complete -F _ud ud

