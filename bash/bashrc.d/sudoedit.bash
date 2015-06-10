# Some imperfect but mostly-useful sudoedit(8) completion
_sudoedit() {
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
    esac
}
complete -F _sudoedit -o default sudoedit

