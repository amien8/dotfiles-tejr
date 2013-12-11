# Count files
cf() {
    local dir dgs ngs
    local -a files

    # Record current state of dotglob and nullglob
    shopt -pq dotglob && dgs=1
    shopt -pq nullglob && ngs=1

    # Specify directory to check
    dir=${1:-$PWD}

    # Retrieve the files array
    shopt -s dotglob nullglob
    files=("$dir"/*)

    # Reset our options
    ((dgs)) && shopt -s dotglob
    ((ngs)) && shopt -s nullglob

    # Print result
    printf '%d\t%s\n' \
        "${#files[@]}" "$dir"
}

