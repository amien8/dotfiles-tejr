# Bail if no vim(1)
if ! hash vim 2>/dev/null; then
    return
fi

# If Vim exists on the system, use it instead of ex, vi, and view
ex() {
    command vim -e "$@"
}
vi() {
    command vim "$@"
}
view() {
    command vim -R "$@"
}

