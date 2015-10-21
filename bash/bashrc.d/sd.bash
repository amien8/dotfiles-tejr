#
# sd -- sibling/switch directory -- Shortcut to switch to another directory
# with the same parent, i.e. a sibling of the current directory.
#
#     $ pwd
#     /home/you
#     $ sd friend
#     $ pwd
#     /home/friend
#     $ sd you
#     $ pwd
#     /home/you
#
# If no arguments are given and there's only one other sibling, switch to that;
# nice way to quickly toggle between two siblings.
#
#     $ cd -- "$(mktemp -d)"
#     $ pwd
#     /tmp/tmp.ZSunna5Eup
#     $ mkdir a b
#     $ ls
#     a b
#     $ cd a
#     pwd
#     /tmp/tmp.ZSunna5Eup/a
#     $ sd
#     $ pwd
#     /tmp/tmp.ZSunna5Eup/b
#     $ sd
#     $ pwd
#     /tmp/tmp.ZSunna5Eup/a
#
# Seems to work for symbolic links. Completion included.
#
sd() {

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

    # Set up local variable for the sibling to which we'll attempt to move,
    # assuming we find one
    local dirname

    # If we have one argument, it's easy, we just try to move to that one
    if (($# == 1)) ; then
        dirname=$1

    # If no argument, the user is lazy; if there's only one sibling, we'll do
    # what they mean and switch to it
    elif (($# == 0)) ; then

        # This subshell switches on globbing functions to try to find all the
        # current directory's siblings; it exits non-zero if it found anything
        # other than one
        if ! dirname=$(
            shopt -s dotglob extglob nullglob
            local -a siblings

            # Generate relative paths of all siblings
            siblings=(../!("${PWD##*/}")/)

            # Strip the trailing slash
            siblings=("${siblings[@]%/}")

            # Strip everything up to the basename
            siblings=("${siblings[@]##*/}")

            # If some number of siblings besides one, exit non-zero
            if ((${#siblings[@]} != 1)) ; then
                exit 1
            fi

            # Otherwise, just print it
            printf %s "${siblings[0]}"

        # This block is run if the subshell fails due to there not being a
        # single sibling
        ) ; then
            printf 'bash: %s: No single sibling directory\n' \
                "$FUNCNAME" >&2
            return 1
        fi

    # Any other number of arguments is a usage error; say so
    else
        printf 'bash: %s: usage: %s [DIR]\n' \
            "$FUNCNAME" "$FUNCNAME" >&2
        return 2
    fi

    # Try to change into the determined directory
    builtin cd "${opts[@]}" ../"$dirname"
}

# Completion function for sd; any sibling directories, excluding the self
_sd() {

    # Only makes sense for the first argument
    ((COMP_CWORD == 1)) || return 1

    # Current directory can't be root directory
    [[ $PWD != / ]] || return 1

    # Build list of matching sibiling directories
    while IFS= read -d '' -r dirname ; do
        COMPREPLY=("${COMPREPLY[@]}" "$dirname")
    done < <(

        # Set options to glob correctly
        shopt -s dotglob extglob nullglob

        # Collect directory names, exclude current directory, strip leading ../
        # and trailing /
        local -a dirnames
        dirnames=(../"${COMP_WORDS[COMP_CWORD]}"*/)
        dirnames=("${dirnames[@]#../}")
        dirnames=("${dirnames[@]%/}")

        # Iterate again, but exclude the current directory this time
        local -a sibs
        local dirname
        for dirname in "${dirnames[@]}" ; do
            [[ $dirname != "${PWD##*/}" ]] || continue
            sibs=("${sibs[@]}" "$dirname")
        done

        # Bail if no results to prevent empty output
        ((${#sibs[@]})) || exit 1

        # Print results, null-delimited
        printf '%q\0' "${sibs[@]}"
    )
}
complete -F _sd sd

