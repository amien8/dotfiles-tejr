# Print arguments, one per line. Compare paz().
pa() {
    if (($#)) ; then
        printf '%s\n' "$@"
    fi
}

