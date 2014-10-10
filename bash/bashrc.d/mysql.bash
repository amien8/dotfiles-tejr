# Bail if no mysql(1)
if ! hash mysql 2>/dev/null ; then
    return
fi

# If a file ~/.mysql/$1.cnf exists, call mysql(1) using that file. Otherwise
# just run MySQL with given args. Use restrictive permissions on these files.
# Examples:
#
#   [client]
#   host=dbhost.example.com
#   user=foo
#   database=bar
#   password=SsJ2pICe226jM
#
mysql() {
    local config="$HOME"/.mysql/"$1".cnf
    if [[ -r $config ]] ; then
        shift
        command mysql --defaults-extra-file="$config" "$@"
    else
        command mysql "$@"
    fi
}

# Completion setup for MySQL for configured databases
_mysql() {
    local word=${COMP_WORDS[COMP_CWORD]}

    # Check directory exists and has at least one .cnf file
    local dir="$HOME"/.mysql
    if [[ ! -d $dir ]] || (
        shopt -s nullglob dotglob
        declare -a files=("$dir"/*.cnf)
        ((! ${#files[@]}))
    ) ; then
        COMPREPLY=()
        return 1
    fi

    # Return the names of the .cnf files sans prefix as completions
    local -a items=("$dir"/*.cnf)
    items=("${items[@]##*/}")
    items=("${items[@]%%.cnf}")
    COMPREPLY=( $(compgen -W "${items[*]}" -- "$word") )
}
complete -F _mysql -o default mysql

