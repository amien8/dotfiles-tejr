# Bail if no tmux(1)
if ! hash tmux 2>/dev/null ; then
    return
fi

# Attach to existing tmux session rather than create a new one if possible
tmux() {
    local -a tcmd

    # If sessions exist, default the arguments to the attach-session command
    if ! (($#)) ; then
        if command tmux has-session 2>/dev/null ; then
            tcmd=(attach-session -d)
        else
            tcmd=(new-session -s "${TMUX_SESSION:-default}")
        fi

    # Otherwise, just call tmux directly with the given arguments
    else
        tcmd=("$@")
    fi

    # Run tmux command with concluded arguments
    command tmux "${tcmd[@]}"
}

