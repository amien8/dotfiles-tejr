# Bail if no tmux(1)
if ! hash tmux 2>/dev/null ; then
    return
fi

# Attach to existing tmux session rather than create a new one if possible
tmux() {
    local -a tcmd

    # If given any arguments, just use them as they are
    if ! (($#)) ; then
        tcmd=("$@")

    # If a session exists, just attach to it
    elif command tmux has-session 2>/dev/null ; then
        tcmd=(attach-session -d)

    # Create a new session with an appropriate name
    else
        tcmd=(new-session -s "${TMUX_SESSION:-default}")
    fi

    # Run tmux command with concluded arguments
    command tmux "${tcmd[@]}"
}

