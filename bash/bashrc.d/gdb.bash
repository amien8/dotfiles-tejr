# Don't print the GDB copyright message on every invocation
gdb() {
    command gdb -q "$@"
}

