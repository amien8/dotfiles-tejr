#
# Main function for bashkeep; provided with a list of NAMEs, whether shell
# functions or variables, writes the current definition of each NAME to a
# directory $BASHKEEP (defaults to ~/.bashkeep.d) with a .bash suffix, each
# of which is reloaded each time this file is called. This allows you to
# quickly arrange to keep that useful shell function or variable you made
# inline on subsequent logins.
#
keep() {

    # Figure out the directory to which we're reading and writing these scripts
    local bashkeep
    bashkeep=${BASHKEEP:-$HOME/.bashkeep.d}
    mkdir -p -- "$bashkeep" || return

    # Parse options
    local opt delete
    local OPTERR OPTIND OPTARG
    while getopts 'dh' opt ; do
        case $opt in

            # -d given; means delete the keepfiles for the given names
            d)
                delete=1
                ;;

            # -h given; means show help
            h)
                cat <<EOF
$FUNCNAME: Keep variables and functions in shell permanently by writing them to
named scripts iterated on shell start, in \$BASHKEEP (defaults to
~/.bashkeep.d).

USAGE:
  $FUNCNAME
    List all the current kept variables and functions
  $FUNCNAME NAME1 [NAME2 ...]
    Write the current definition for the given NAMEs to keep files
  $FUNCNAME -d NAME1 [NAME2 ...]
    Delete the keep files for the given NAMEs
  $FUNCNAME -h
    Show this help

EOF
                return
                ;;

            # Unknown other option
            \?)
                printf 'bash: %s -%s: invalid option\n' \
                    "$FUNCNAME" "$opt" >&2
                return 2
                ;;
        esac
    done
    shift "$((OPTIND-1))"

    # If any arguments left, we must be either keeping or deleting
    if (($#)) ; then

        # Start keeping count of any errors
        local -i errors
        errors=0

        # Iterate through the NAMEs given
        local name
        for name in "$@" ; do

            # Check NAMEs for validity
            case $name in

                # NAME must start with letters or an underscore, and contain no
                # characters besides letters, numbers, or underscores
                *[^a-zA-Z0-9_]*|[^a-zA-Z_]*)
                    printf 'bash: %s: %s not a valid NAME\n' \
                        "$FUNCNAME" "$name" >&2
                    ((errors++))
                    ;;

                # NAME is valid, proceed
                *)

                    # If -d was given, delete the keep files for the NAME
                    if ((delete)) ; then
                        rm -- "$bashkeep"/"$name".bash \
                            || ((errors++))

                    # Otherwise, attempt to create the keep file, using an
                    # appropriate call to the declare builtin
                    else
                        { case $(type -t "$name") in
                            'function')
                                declare -f -- "$name"
                                ;;
                            *)
                                declare -p -- "$name"
                                ;;
                        esac ; } > "$bashkeep"/"$name".bash \
                            || ((errors++))
                    fi
                    ;;
            esac
        done

        # Return 1 if we accrued any errors, 0 otherwise
        return "$((errors > 0))"
    fi

    # Deleting is an error, since we need at least one argument
    if ((delete)) ; then
        printf 'bash: %s: must specify at least one NAME to delete\n'
            "$FUNCNAME" >&2
        return 2
    fi

    # Otherwise the user must want us to print all the NAMEs kept
    (
        shopt -s dotglob nullglob
        declare -a keeps
        keeps=("${bashkeep}"/*.bash)
        keeps=("${keeps[@]##*/}")
        keeps=("${keeps[@]%.bash}")
        ((${#keeps[@]})) || exit 0
        printf '%s\n' "${keeps[@]}"
    )
}

# Complete calls to keep with existing function names and variable names
complete -A function -A variable keep

# Load any existing scripts in bashkeep
if [[ -d ${BASHKEEP:-$HOME/.bashkeep.d} ]] ; then
    for bashkeep in "${BASHKEEP:-$HOME/.bashkeep.d}"/*.bash ; do
        [[ -e $bashkeep ]] || continue
        source "$bashkeep"
    done
    unset -v bashkeep
fi

