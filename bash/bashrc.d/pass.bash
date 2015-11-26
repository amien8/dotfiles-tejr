# Requires Bash >= 4.0 for globstar
((BASH_VERSINFO[0] >= 4)) || return

# Custom completion for pass(1), because I don't like the one included with the
# distribution
_pass()
{
    # If we can't read the password directory, just bail
    local passdir
    passdir=${PASSWORD_STORE_DIR:-$HOME/.password-store}
    [[ -r $passdir ]] || return 1

    # Iterate through list of .gpg paths, extension stripped, null-delimited,
    # and filter them down to the ones matching the completing word (compgen
    # doesn't seem to do this properly with a null delimiter)
    local entry
    while IFS= read -d '' -r entry ; do
        COMPREPLY=("${COMPREPLY[@]}" "$entry")
    done < <(

        # Set shell options to expand globs the way we expect
        shopt -u dotglob
        shopt -s globstar nullglob

        # Gather the entries and remove their .gpg suffix
        declare -a entries
        entries=("$passdir"/"${COMP_WORDS[COMP_CWORD]}"*/**/*.gpg \
            "$passdir"/"${COMP_WORDS[COMP_CWORD]}"*.gpg)
        entries=("${entries[@]#$passdir/}")
        entries=("${entries[@]%.gpg}")

        # Bail if no entries to prevent empty output
        ((${#entries[@]})) || exit 1

        # Print all the entries, null-delimited
        printf '%q\0' "${entries[@]}"
    )
}
complete -F _pass pass

