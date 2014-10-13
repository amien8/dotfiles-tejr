# Completion for pass(1), adapted from source package; still needs some tweaking
_pass()
{
    # Bail if no pass(1)
    if ! hash pass 2>/dev/null ; then
        COMPREPLY=()
        return 1
    fi

    # Get current word, prefix, and suffix
    local word=${COMP_WORDS[COMP_CWORD]}
    local prefix=${PASSWORD_STORE_DIR:-$HOME/.password-store}
    local suffix=.gpg

    # Iterate through possible completions
    local IFS=$'\n'
    local items=( $(compgen -f "$prefix"/"$word") )
    local item
    for item in "${items[@]}" ; do
        if [[ $item == "$prefix"/.* ]] ; then
            continue
        fi

        # If there is a unique match, and it is a directory with one entry, then
        # recursively autocomplete the subentry as well
        if ((${#items[@]} == 1)) ; then
            local subitems
            while [[ -d $item ]] ; do
                subitems=( $(compgen -f "$item"/) )
                if ((${#subitems[@]} == 1)) ; then
                    item=${subitems[0]}
                else
                    break
                fi
            done
        fi

        # Append slash to directories
        if [[ -d $item ]] ; then
            item=$item/
        fi

        # Add item to possible completions
        item=${item%$suffix}
        item=${item#$prefix/}
        COMPREPLY=("${COMPREPLY[@]}" "$item")
    done
}

# Completion only has -o nospace in Bash >=3.0
if ((BASH_VERSINFO[0] >= 3)) ; then
    complete -o filenames -o nospace -F _pass pass
else
    complete -o filenames -F _pass pass
fi

