# If Vim exists on the system, use it instead of ex, vi, and view
ex() {
    if hash vim 2>/dev/null; then
        command vim -e "$@"
    else
        command ex "$@"
    fi
}
vi() {
    if hash vim 2>/dev/null; then
        command vim "$@"
    else
        command vi "$@"
    fi
}
view() {
    if hash vim 2>/dev/null; then
        command vim -R "$@"
    else
        command view "$@"
    fi
}

