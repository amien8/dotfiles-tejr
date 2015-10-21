# Run a command and push its stdout and stderr into temporary files, printing
# the names of the files once done, and saving them into two variables. Return
# the exit status of the command.
#
#     $ fnl grep foo /bar
#     declare -p fnl_stdout="/tmp/fnl.xQmhe/stdout"
#     declare -p fnl_stderr="/tmp/fnl.xQmhe/stderr"
#
fnl() {

    # Must be called with at least one command argument
    if ! (($#)) ; then
        printf 'bash: %s: usage: %s COMMAND [ARG1 ...]\n' \
            "$FUNCNAME" "$FUNCNAME" >&2
        return 2
    fi

    # Try to stop infinitely recursive calls
    if [[ $1 == "$FUNCNAME" ]] ; then
        printf 'bash: %s: Cannot nest calls\n' \
            "$FUNCNAME" >&2
        return 2
    fi

    # Create a temporary directory or bail
    local template dirname
    template=$FUNCNAME.$1.XXXXX
    if ! dirname=$(mktemp -dt -- "$template") ; then
        return
    fi

    # Run the command and save its exit status
    local ret
    "$@" >"$dirname"/stdout 2>"$dirname"/stderr
    ret=$?

    # Note these are *not* local variables
    # shellcheck disable=SC2034
    fnl_stdout=$dirname/stdout fnl_stderr=$dirname/stderr
    declare -p fnl_std{out,err}

    # Return the exit status of the command, not the declare builtin
    return "$ret"
}

