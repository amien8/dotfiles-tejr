# Show reminders on login
if command -v remind >/dev/null 2>&1 && [ -f "$HOME"/.reminders ] ; then
    printf '\n'
    remind -q "$HOME"/.reminders
fi

