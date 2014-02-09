# Show reminders on login
if command -v remind >/dev/null 2>&1 && [ -r "$HOME"/.reminders ] ; then
    printf '\n'
    remind -q "$HOME"/.reminders | sed 's/^/* /'
fi

