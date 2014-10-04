# Move back up the directory tree to the first directory matching the name
bd() {

    # If there are no arguments, we just move up one directory (cd ..)
    if [[ $1 ]] ; then
        dir="${PWD%/${1:?}*}"/"$1"
    else
        dir=..
    fi

    # Check the directory exists and try to cd into it if possible
    if [[ -d $dir ]] ; then
        builtin cd -- "$dir"
    else
        printf 'bash: No dir found in PWD named %s\n' "$1" >&2
        return 1
    fi
}

# Completion setup for bd
_bd() {
    local word=${COMP_WORDS[COMP_CWORD]}

    # Build a list of dirs in $PWD
    local -a dirs
    while read -d / -r dir ; do
        if [[ $dir ]] ; then
            dirs=("${dirs[@]}" "$dir")
        fi
    done < <(printf %s "$PWD")

    # Complete with matching dirs
    COMPREPLY=( $(compgen -W "${dirs[*]}" -- "$word") )
}
complete -F _bd bd

