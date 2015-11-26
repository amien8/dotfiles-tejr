# Autocompletion for man(1)
_man() {

    # Don't even bother if we don't have manpath(1)
    hash manpath || return 1

    # Snarf the word
    local word
    word=${COMP_WORDS[COMP_CWORD]}

    # If this is the second word, and the previous word was a number, we'll
    # assume that's the section to search
    local section 
    if ((COMP_CWORD > 1)) && [[ ${COMP_WORDS[COMP_CWORD-1]} != [^0-9] ]] ; then
        section='man'${COMP_WORDS[COMP_CWORD-1]}
    fi

    # Read slash-separated output from a subshell into the COMPREPLY array
    IFS=/ read -a COMPREPLY -d '' -r < <(

        # Do not return dotfiles, and expand empty globs to just nothing
        shopt -u dotglob
        shopt -s nullglob

        # Start an array of pages
        declare -a pages

        # Break manpath(1) output into an array of paths
        IFS=: read -a manpaths -r < <(manpath 2>/dev/null)

        # Iterate through the manual page paths and add every manual page we find
        for manpath in "${manpaths[@]}" ; do
            [[ $manpath ]] || continue
            pages=("${pages[@]}" "$manpath"/"$section"*/"$word"*)
        done

        # Strip paths, .gz suffixes, and finally .<section> suffixes
        pages=("${pages[@]##*/}")
        pages=("${pages[@]%.gz}")
        pages=("${pages[@]%.*}")

        # Bail out if we ended up with no pages somehow to prevent us from
        # printing
        ((${#pages[@]})) || exit 1

        # Print the pages array to stdout, newline-separated; see above
        # explanation
        (IFS=/ ; printf '%q\0' "${pages[*]}")
    )
}
complete -F _man -o default man

