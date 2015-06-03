# Requires Bash >= 4.0 for read -i and ${!name}
if ((10#${BASH_VERSINFO[0]%%[![:digit:]]*} < 4)) ; then
    return
fi

# Edit named variables' values
vared() {
    local opt prompt
    local OPTERR OPTIND OPTARG
    while getopts 'p:' ; do
        case $opt in
            p)
                prompt=$OPTARG
                ;;
            \?)
                printf 'bash: %s: -%s: invalid option\n'
                    "$FUNCNAME" "$opt" >&2
                return 2
                ;;
        esac
    done
    shift "$((OPTIND-1))"
    if ! (($#)) ; then
        printf 'bash: %s: No variable names given\n' \
            "$FUNCNAME" >&2
        return 2
    fi
    local name
    for name in "$@" ; do
        IFS= read -e -i "${!name}" -p "${prompt:-$name=}" -r -- "$name"
    done
}
complete -A variable vared

