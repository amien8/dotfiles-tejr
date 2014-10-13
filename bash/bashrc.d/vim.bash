# If Vim exists on the system, use it instead of ex, vi, and view
if hash vim 2>/dev/null ; then
    alias ex='vim -e'
    alias vi='vim'
    alias view='vim -R'
fi

