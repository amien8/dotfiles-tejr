# Add a colon prompt to ed when a command is expected rather than text; makes
# it feel a lot more like using ex. Only do this when stdin is a terminal,
# however.
ed() {
    if [[ -t 0 ]] ; then
        command ed -p: "$@"
    else
        command ed "$@"
    fi
}

