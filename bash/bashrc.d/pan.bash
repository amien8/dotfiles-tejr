# Print arguments, null-delimited; you will probably want to write this into a
# file or as part of a pipeline
pan() {
    printf '%s\0' "$@"
}

