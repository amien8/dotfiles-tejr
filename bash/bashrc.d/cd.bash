# If given two arguments to cd, replace the first with the second in $PWD,
# emulating a Zsh function that I often find useful; preserves options too
cd() {
    local arg
    local -a opts
    for arg in "$@" ; do
        if [[ $arg == -- ]] ; then
            shift
            break
        elif [[ $arg == -* ]] ; then
            shift
            opts=("${opts[@]}" "$arg")
        fi
    done
    if (($# == 2)) ; then
        if [[ $PWD == *"$1"* ]] ; then
            builtin cd "${opts[@]}" -- "${PWD/$1/$2}"
        else
            printf 'bash: cd: could not replace substring\n' >&2
            return 1
        fi
    else
        builtin cd "${opts[@]}" -- "$@"
    fi
}

