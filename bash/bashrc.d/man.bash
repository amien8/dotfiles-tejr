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

    #
    # Read newline-separated output from a subshell into the COMPREPLY array.
    #
    # This is subtly wrong. Given that it's just a path, there's theoretically
    # no reason that the name of a man(1) page couldn't contain a newline. If
    # one of them does, then this method will include some junk manual page
    # names. But who on earth makes a manual page with a newline in the name?
    #
    # Using null separators doesn't work, because read prioritises reading the
    # end of the line before it does field-splitting, and filling COMPREPLY
    # entry-by-entry is *really* slow, so this is the least-wrong solution I
    # could come up with that allows me to use a subshell to elegantly set
    # globbing shell options.
    #
    IFS=$'\n' read -a COMPREPLY -d '' -r < <(

        # Don't return dotfiles, and expand empty globs to just nothing
        shopt -u dotglob
        shopt -s nullglob

        # Start an array of pages
        declare -a pages

        # Break manpath(1) output into an array of paths
        IFS=: read -a manpaths -r < <(manpath)

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
        (IFS=$'\n' ; printf '%s\0' "${pages[*]}")
    )
}
complete -F _man -o default man

