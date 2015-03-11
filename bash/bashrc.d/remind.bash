# Default filename for remind(1) is ~/.reminders
remind() {
    command remind "${@:-"$HOME"/.reminders}"
}

