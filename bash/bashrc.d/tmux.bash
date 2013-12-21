# Bail if no tmux(1)
if ! hash tmux 2>/dev/null; then
    return
fi

# Attach to existing tmux session rather than create a new one if possible
tmux() {

    # If sessions exist, default the arguments to the attach-session command
    if ! (($#)) && command tmux has-session 2>/dev/null; then
        command tmux attach-session -d

    # Otherwise, just call tmux directly with the given arguments
    else
        command tmux "$@"
    fi
}

