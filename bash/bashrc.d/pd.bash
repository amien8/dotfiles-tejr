# Attempt to change into the argument's parent directory; preserve any options
# and pass them to cd. This is intended for use when you've got a file path in
# a variable, or in history, or in Alt+., and want to quickly move to its
# containing directory. In the absence of an argument, this just shifts up a
# directory, i.e. `cd ..`
pd() {
    local arg
    local -a opts
    for arg in "$@" ; do
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
    if (($#)) ; then
        case $# in
            1)
                target=$1
                target=${target%/}
                target=${target%/*}
                ;;
            2)
                printf 'bash: pd: too many arguments\n' >&2
                return 1
                ;;
        esac
    else
        target=..
    fi
    if [[ $target ]] ; then
        builtin cd "${opts[@]}" -- "$target"
    else
        printf 'bash: pd: error calculating parent directory\n' >&2
        return 1
    fi
}

