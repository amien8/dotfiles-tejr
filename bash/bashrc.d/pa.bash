# Print arguments
pa() {
    if (($#)) ; then
        printf '%s\n' "$@"
    fi
}

