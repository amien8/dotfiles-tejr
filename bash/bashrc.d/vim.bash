# If Vim exists on the system, use it instead of vi
vi() {
    if hash vim 2>/dev/null; then
        command vim "$@"
    else
        command vi "$@"
    fi
}

