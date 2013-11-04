# If given two arguments to cd, replace the first with the second in $PWD,
# emulating a Zsh function that I often find useful; preserves options too
cd() {
    local arg dir endopts
    local -a opts dirs
    for arg in "$@"; do
        if [[ $arg == -- ]]; then
            endopts=1
        elif [[ $arg == -* ]] && ! ((endopts)); then
            opts=("${opts[@]}" "$arg")
        else
            dirs=("${dirs[@]}" "$arg")
        fi
    done
    if (($# == 2)); then
        if [[ $PWD == *"$1"* ]]; then
            builtin cd "${opts[@]}" "${PWD/$1/$2}"
        else
            printf '%s\n' 'bash: cd: could not replace substring' >&2
            return 1
        fi
    else
        builtin cd "${opts[@]}" "${dirs[@]}"
    fi
}

