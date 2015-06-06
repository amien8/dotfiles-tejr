# Requires Bash >= 4.0 for dotglob, nullglob, and globstar
if ((10#${BASH_VERSINFO[0]%%[![:digit:]]*} < 4)) ; then
    return
fi

# Custom completion for pass(1), because I don't like the one included with the
# distribution
_pass()
{
    # If we can't read the password directory, just bail
    local passdir
    passdir=${PASSWORD_STORE_DIR:-$HOME/.password-store}
    if [[ ! -r $passdir ]] ; then
        return 1
    fi

    # Iterate through list of .gpg paths, extension stripped, null-delimited,
    # and filter them down to the ones matching the completing word (compgen
    # doesn't seem to do this properly with a null delimiter)
    local word entry
    word=${COMP_WORDS[COMP_CWORD]}
    while read -d '' -r entry ; do
        if [[ $entry == "$word"* ]] ; then
            COMPREPLY=("${COMPREPLY[@]}" "$entry")
        fi
    done < <(

        # Set shell options to expand globs the way we expect
        shopt -u dotglob
        shopt -s nullglob
        shopt -s globstar

        # Change into password directory, or bail
        cd -- "$passdir" 2>/dev/null || exit

        # Gather the entries and remove their .gpg suffix
        declare -a entries
        entries=(**/*.gpg)
        entries=("${entries[@]%.gpg}")

        # Print all the entries, null-delimited
        if ((${#entries[@]})) ; then
            printf '%s\0' "${entries[@]}"
        fi
    )
}
complete -F _pass pass

