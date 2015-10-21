# Completion for git local branch names
_git() {

    # Bail if not a git repo (or no git!)
    git rev-parse --git-dir >/dev/null 2>&1 || return 1

    # Switch on the previous word
    case ${COMP_WORDS[1]} in

        # If the first word is appropriate, complete with branch/tag names
        checkout|merge|rebase)
            local branch
            while read -r branch ; do
                [[ $branch == "${COMP_WORDS[COMP_CWORD]}"* ]] || continue
                COMPREPLY=("${COMPREPLY[@]}" "$branch")
            done < <(git for-each-ref refs/{heads,tags} 2>/dev/null)
            return
            ;;

        # Bail if it isn't
        *)
            return 1
            ;;
    esac
}
complete -F _git -o default git

