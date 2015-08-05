# Move back up the directory tree to the first directory matching the name
bd() {
    local dir

    # If there are no arguments, we just move up one directory (cd ..)
    if (($#)) ; then
        dir="${PWD%/$1*}"/"$1"
    else
        dir=..
    fi

    # Check the directory exists and try to cd into it if possible
    if [[ -d $dir ]] ; then
        builtin cd -- "$dir"
    else
        printf 'bash: %s: No dir found in PWD named %s\n' \
            "$FUNCNAME" "$1" >&2
        return 1
    fi
}

# Completion setup for bd
_bd() {
    local word
    word=${COMP_WORDS[COMP_CWORD]}

    # Build a list of dirs in $PWD
    local -a dirs
    while read -d / -r dir ; do
        if [[ -n $dir ]] ; then
            dirs=("${dirs[@]}" "$dir")
        fi
    done < <(printf %s "$PWD")

    # Complete with matching dirs
    COMPREPLY=( $(compgen -W "${dirs[*]}" -- "$word") )
}
complete -F _bd bd

