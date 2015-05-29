# Requires Bash >= 4.0 for dotglob and globstar
if ((${BASH_VERSINFO[0]} < 4)) ; then
    return
fi

# Custom completion for pass(1), because I don't like the one included with the
# distribution
_pass()
{
    local word=${COMP_WORDS[COMP_CWORD]}

    # Iterate through list of .gpg paths, extension stripped, null-delimited
    local entry
    while read -d '' -r entry ; do
        if [[ $entry == "$word"* ]] ; then
            COMPREPLY=("${COMPREPLY[@]}" "$entry")
        fi

    # This part provides the input to the while loop
    done < <(

        # Set shell options to expand globs the way we expect
        shopt -u dotglob
        shopt -s globstar

        # Figure out password directory and change into it
        passdir=${PASSWORD_STORE_DIR:-$HOME/.password-store}
        cd -- "$passdir" || return

        # Gather the entries and remove their .gpg suffix
        entries=(**/*.gpg)
        entries=("${entries[@]%.gpg}")

        # Print all the entries, null-delimited
        printf '%s\0' "${entries[@]}"
    )
}
complete -F _pass pass

