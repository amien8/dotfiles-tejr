# Count files
cf() {
    local dir dgs ngs
    local -a files

    # Specify directory to check
    dir=${1:-$PWD}
    if [[ ! -d $dir ]]; then
        printf 'bash: cf: %s is not a directory\n' \
            "$dir" >&2
        return 1
    fi

    # Record current state of dotglob and nullglob
    shopt -pq dotglob && dgs=1
    shopt -pq nullglob && ngs=1

    # Retrieve the files array
    shopt -s dotglob nullglob
    files=("$dir"/*)

    # Reset our options
    ((dgs)) || shopt -u dotglob
    ((ngs)) || shopt -u nullglob

    # Print result
    printf '%d\t%s\n' \
        "${#files[@]}" "$dir"
}

