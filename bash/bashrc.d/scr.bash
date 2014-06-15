# Create a temporary directory and change into it, to stop me putting stray
# files into $HOME, and making the system do cleanup for me
scr() {
    pushd -- "$(mktemp -d)"
}

