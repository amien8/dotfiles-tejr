# Add the -H parameter to sudo(8) calls, always use the target user's $HOME
sudo() {
    if [[ $1 == -v ]] ; then
        command sudo "$@"
    else
        command sudo -H "$@"
    fi
}

# Some imperfect but mostly-useful sudo(8) completion
_sudo() {
    word=${COMP_WORDS[COMP_CWORD]}
    prev=${COMP_WORDS[COMP_CWORD-1]}

    # Completion for this word depends on the previous word
    case $prev in

        # If the previous word was an option for -g, complete with group names
        -*g)
            COMPREPLY=( $(compgen -A group -- "$word") )
            ;;

        # If the previous word was an option for -u, complete with user names
        -*u)
            COMPREPLY=( $(compgen -A user -- "$word") )
            ;;

        # Otherwise complete with commands
        *)
            COMPREPLY=( $(compgen -A command -- "$word") )
            ;;
    esac
}
complete -F _sudo -o default sudo

