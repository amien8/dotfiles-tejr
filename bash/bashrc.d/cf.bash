# Count files
cf() {
    local dir dgs ngs
    local -a files

    # Specify directory to check
    dir=${1:-$PWD}

    # Error conditions
    if [[ ! -e $dir ]] ; then
        printf 'bash: cf: %s does not exist\n' "$dir" >&2
        return 1
    elif [[ ! -d $dir ]] ; then
        printf 'bash: cf: %s is not a directory\n' "$dir" >&2
        return 1
    elif [[ ! -r $dir ]] ; then
        printf 'bash: cf: %s is not readable\n' "$dir" >&2
        return 1
    fi

    # Record current state of dotglob and nullglob
    if shopt -pq dotglob ; then
        dgs=1
    fi
    if shopt -pq nullglob ; then
        ngs=1
    fi

    # Retrieve the files array
    shopt -s dotglob nullglob
    files=("$dir"/*)

    # Reset our options
    if ! ((dgs)) ; then
        shopt -u dotglob
    fi
    if ! ((ngs)) ; then
        shopt -u nullglob
    fi

    # Print result
    printf '%d\t%s\n' "${#files[@]}" "$dir"
}

