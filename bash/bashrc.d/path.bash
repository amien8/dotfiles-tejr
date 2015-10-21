# Function to manage contents of PATH variable within the current shell
path() {

    # Figure out command being called
    local pathcmd
    if (($#)) ; then
        pathcmd=$1
        shift
    else
        pathcmd=list
    fi

    # Switch between commands
    case $pathcmd in

        # Print help output (also done if command not found)
        help|h|-h|--help|-\?)
            cat <<EOF
$FUNCNAME: Manage contents of PATH variable

USAGE:
  $FUNCNAME h[elp]
    Print this help message (also done if command not found)
  $FUNCNAME l[ist]
    Print the current directories in PATH, one per line (default command)
  $FUNCNAME i[nsert] DIR
    Add a directory to the front of PATH, checking for existence and uniqueness
  $FUNCNAME a[ppend] DIR
    Add a directory to the end of PATH, checking for existence and uniqueness
  $FUNCNAME r[emove] DIR
    Remove all instances of a directory from PATH

INTERNALS:
  $FUNCNAME s[et] [DIR1 [DIR2...]]
    Set the PATH to the given directories without checking existence or uniqueness
  $FUNCNAME c[heck] DIR
    Return whether DIR is a component of PATH

EOF
            ;;

        # Print the current contents of the path
        list|l)
            local -a patharr
            IFS=: read -a patharr < <(printf '%s\n' "$PATH")
            if ((${#patharr[@]})) ; then
                printf '%s\n' "${patharr[@]}"
            fi
            ;;

        # Add a directory to the front of PATH, checking for existence and uniqueness
        insert|i)
            local -a patharr
            IFS=: read -a patharr < <(printf '%s\n' "$PATH")
            local dirname
            dirname=$1
            [[ $dirname == / ]] || dirname=${dirname%/}
            if [[ -z $dirname ]] ; then
                printf 'bash: %s: need a directory path to insert\n' \
                    "$FUNCNAME" >&2
                return 1
            fi
            if [[ ! -d $dirname ]] ; then
                printf 'bash: %s: %s not a directory\n' \
                    "$FUNCNAME" "$dirname" >&2
                return 1
            fi
            if [[ $dirname == *:* ]] ; then
                printf 'bash: %s: Cannot add insert directory %s with colon in name\n' \
                    "$FUNCNAME" "$dirname" >&2
                return 1
            fi
            if path check "$dirname" ; then
                printf 'bash: %s: %s already in PATH\n' \
                    "$FUNCNAME" "$dirname" >&2
                return 1
            fi
            patharr=("$dirname" "${patharr[@]}")
            path set "${patharr[@]}"
            ;;

        # Add a directory to the end of PATH, checking for existence and uniqueness
        append|add|a)
            local -a patharr
            IFS=: read -a patharr < <(printf '%s\n' "$PATH")
            local dirname
            dirname=$1
            [[ $dirname == / ]] || dirname=${dirname%/}
            if [[ -z $dirname ]] ; then
                printf 'bash: %s: need a directory path to append\n' \
                    "$FUNCNAME" >&2
                return 1
            fi
            if [[ ! -d $dirname ]] ; then
                printf 'bash: %s: %s not a directory\n' \
                    "$FUNCNAME" "$dirname" >&2
                return 1
            fi
            if [[ $dirname == *:* ]] ; then
                printf 'bash: %s: Cannot append directory %s with colon in name\n' \
                    "$FUNCNAME" "$dirname" >&2
                return 1
            fi
            if path check "$dirname" ; then
                printf 'bash: %s: %s already in PATH\n' \
                    "$FUNCNAME" "$dirname" >&2
                return 1
            fi
            patharr=("${patharr[@]}" "$dirname")
            path set "${patharr[@]}"
            ;;

        # Remove all instances of a directory from PATH
        remove|rm|r)
            local -a patharr
            IFS=: read -a patharr < <(printf '%s\n' "$PATH")
            local dirname
            dirname=$1
            [[ $dirname == / ]] || dirname=${dirname%/}
            if [[ -z $dirname ]] ; then
                printf 'bash: %s: need a directory path to remove\n' \
                    "$FUNCNAME" >&2
                return 1
            fi
            if ! path check "$dirname" ; then
                printf 'bash: %s: %s not in PATH\n' \
                    "$FUNCNAME" "$dirname" >&2
                return 1
            fi
            local -a newpatharr
            local part
            for part in "${patharr[@]}" ; do
                [[ $dirname == "$part" ]] && continue
                newpatharr=("${newpatharr[@]}" "$part")
            done
            path set "${newpatharr[@]}"
            ;;

        # Set the PATH to the given directories without checking existence or uniqueness
        set|s)
            local -a newpatharr
            local dirname
            for dirname ; do
                newpatharr=("${newpatharr[@]}" "$dirname")
            done
            PATH=$(IFS=: ; printf '%s' "${newpatharr[*]}")
            ;;

        # Return whether directory is a component of PATH
        check|c)
            local -a patharr
            IFS=: read -a patharr < <(printf '%s\n' "$PATH")
            local dirname
            dirname=$1
            [[ $dirname == / ]] || dirname=${dirname%/}
            if [[ -z $dirname ]] ; then
                printf 'bash: %s: need a directory path to check\n' \
                    "$FUNCNAME" >&2
                return 1
            fi
            local part
            for part in "${patharr[@]}" ; do
                if [[ $dirname == "$part" ]] ; then
                    return 0
                fi
            done
            return 1
            ;;

        # Unknown command
        *)
            printf 'bash: %s: Unknown command %s\n' \
                "$FUNCNAME" "$pathcmd" >&2
            path help >&2
            return 1
            ;;
    esac
}

# Completion for path
_path() {

    # What to do depends on which word we're completing
    case $COMP_CWORD in

        # Complete operation as first word
        1)
            for cmd in help list insert append remove set check ; do
                [[ $cmd == "${COMP_REPLY[COMP_CWORD]}"* ]] || continue
                COMPREPLY=("${COMPREPLY[@]}" "$cmd")
            done
            ;;

        # Complete with either directories or $PATH entries as all other words
        *)
            case ${COMP_WORDS[1]} in

                # Complete with a directory
                insert|i|append|add|a|check|c|set|s)
                    local dirname
                    while IFS= read -d '' -r dirname ; do
                        COMPREPLY=("${COMPREPLY[@]}" "$dirname")
                    done < <(

                        # Set options to glob correctly
                        shopt -s dotglob nullglob

                        # Collect directory names, strip trailing slash
                        local -a dirnames
                        dirnames=("${COMP_WORDS[COMP_CWORD]}"*/)
                        dirnames=("${dirnames[@]%/}")

                        # Bail if no results to prevent empty output
                        ((${#dirnames[@]})) || exit 1

                        # Print results, null-delimited
                        printf '%s\0' "${dirnames[@]}"
                    )
                    ;;

                # Complete with directories from PATH
                remove|rm|r)
                    local -a promptarr
                    IFS=: read -d '' -a promptarr < <(printf '%s\0' "$PATH")
                    local part
                    for part in "${promptarr[@]}" ; do
                        [[ $part == "${COMP_WORDS[COMP_CWORD]}"* ]] \
                            || continue
                        COMPREPLY=("${COMPREPLY[@]}" "$part")
                    done
                    ;;

                # No completion
                *)
                    return 1
                    ;;
            esac
            ;;
    esac
}

# The use of -o filenames isn't strictly correct. The first completed world
# will actually just be a simple string, the sub-command to use. However in
# practice it doesn't matter as it's a fixed set of strings that won't be
# quoted anyway.
complete -F _path -o filenames path

