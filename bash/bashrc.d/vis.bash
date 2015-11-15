# Complete args to vis(1) with existing executables in $VISPATH, defaulting to
# ~/.local/bin
_vis() {
    local vispath
    vispath=${VISPATH:-$HOME/.local/bin}
    [[ -d $vispath ]] || return
    while IFS= read -d '' -r executable ; do
        COMPREPLY=("${COMPREPLY[@]}" "$executable")
    done < <(
        shopt -s dotglob nullglob
        declare -a files
        files=("${VISPATH:-$HOME/.local/bin}"/"${COMP_WORDS[COMP_CWORD]}"*)
        declare -a executables
        for file in "${files[@]}" ; do
            [[ -f $file && -x $file ]] || continue
            executables=("${executables[@]}" "${file##*/}")
        done
        ((${#executables[@]})) || exit 1
        printf '%q\0' "${executables[@]}"
    )
}
complete -F _vis vis

