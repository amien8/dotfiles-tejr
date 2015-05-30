# If Vim exists on the system, use it instead of ex, vi, and view
if hash vim 2>/dev/null ; then
    ex() {
        command vim -e "$@"
    }
    vi() {
        command vim "$@"
    }
    view() {
        command vim -R "$@"
    }
fi

