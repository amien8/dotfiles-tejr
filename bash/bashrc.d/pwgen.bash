# Set some defaults for pwgen, because its defaults are to give me a long list
# of relatively short passwords, when I generally want only one good one
pwgen() {
    if (($#)) ; then
        command pwgen "$@"
    else
        command pwgen --secure -- "${PWGEN_LENGTH:-15}" "${PWGEN_COUNT:-1}"
    fi
}

