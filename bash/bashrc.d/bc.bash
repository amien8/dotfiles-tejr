# Don't print the bc(1) welcome message
bc() {
    command bc -q "$@"
}

