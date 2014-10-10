# Bail if no tmux(1)
if ! hash tmux 2>/dev/null ; then
    return
fi

# Attach to existing tmux session rather than create a new one if possible
tmux() {

    # If given any arguments, just use them as they are
    if (($#)) ; then
        command tmux "$@"

    # If a session exists, just attach to it
    elif command tmux has-session 2>/dev/null ; then
        command tmux attach-session -d

    # Create a new session with an appropriate name
    else
        command tmux new-session -s "${TMUX_SESSION:-default}"
    fi
}

