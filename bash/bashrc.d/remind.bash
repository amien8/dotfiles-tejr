# Default filename for remind(1) is ~/.reminders
remind() {
    if ! (($#)) && [[ -r "$HOME"/.reminders ]] ; then
        command remind "$HOME"/.reminders
    else
        command remind "$@"
    fi
}

