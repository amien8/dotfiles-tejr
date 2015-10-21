# If a file ~/.mysql/$1.cnf exists, call mysql(1) using that file. Otherwise
# just run MySQL with given args. Use restrictive permissions on these files.
# Examples:
#
#   [client]
#   host=dbhost.example.com
#   user=foo
#   password=SsJ2pICe226jM
#
#   [mysql]
#   database=bar
#
mysql() {
    local config
    config=$HOME/.mysql/$1.cnf
    if [[ -r $config ]] ; then
        shift
        command mysql --defaults-extra-file="$config" "$@"
    else
        command mysql "$@"
    fi
}

# Completion setup for MySQL for configured databases
_mysql() {

    # Only makes sense for first argument
    ((COMP_CWORD == 1)) || return 1

    # Bail if directory doesn't exist
    local dirname
    dirname=$HOME/.mysql
    [[ -d $dirname ]] || return 1

    # Return the names of the .cnf files sans prefix as completions
    local db
    while IFS= read -d '' -r db ; do
        [[ $db == "${COMP_WORDS[COMP_CWORD]}"* ]] || continue
        COMPREPLY=("${COMPREPLY[@]}" "$db")
    done < <(

        # Set options so that globs expand correctly
        shopt -s dotglob nullglob

        # Collect all the config file names, strip off leading path and .cnf
        local -a cnfs
        cnfs=("$dirname"/*.cnf)
        cnfs=("${cnfs[@]#$dirname/}")
        cnfs=("${cnfs[@]%.cnf}")

        # Bail if no files to prevent empty output
        ((${#cnfs[@]})) || exit 1

        # Print the conf names, null-delimited
        printf '%s\0' "${cnfs[@]}"
    )
}
complete -F _mysql -o default -o filenames mysql

