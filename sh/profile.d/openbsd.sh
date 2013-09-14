# OpenBSD systems don't handle 256 color terminals the way my Linux systems do,
# seeming to be inconsistent about e.g. the correct number of parameters for
# `tput setaf ...` -- I don't know which of them is right but for the moment
# I'm siding with Linux. This chops off any -256color suffix to the terminal
# name, and also any -unicode suffix.
if [ "$(uname -s)" = "OpenBSD" ]; then
    TERM=${TERM%-256color}
    TERM=${TERM%-unicode}
fi

