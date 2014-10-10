# Make pushd default to $HOME if no arguments given, much like cd
pushd() {
    if (($#)) ; then
        builtin pushd "$@"
    else
        builtin pushd -- "$HOME"
    fi
}

