# If given two arguments to cd, replace the first with the second in $PWD,
# emulating a Zsh function that I often find useful; preserves options too
cd() {
    local opt OPTIND=0
    local -a opts
    while getopts elP opt; do
        opts=("${opts[@]}" -"$opt")
    done
    shift $((OPTIND-1))
    if (($# == 2)); then
        if [[ $PWD == *"$1"* ]]; then
            builtin cd "${opts[@]}" "${PWD/$1/$2}"
        else
            printf '%s\n' 'bash: cd: could not replace substring' >&2
            return 1
        fi
    else
        builtin cd "${opts[@]}" "$@"
    fi
}

