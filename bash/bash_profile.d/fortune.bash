# If interactive shell and fortune(6) installed, print a short fortune
if [[ $- == *i* ]] && hash fortune 2>/dev/null ; then (
    if [[ -d "$HOME"/.local/share/games/fortunes ]] ; then
        FORTUNE_PATH=${FORTUNE_PATH:-$HOME/.local/share/games/fortunes}
    fi
    fortune -sn "${FORTUNE_MAXSIZE:-768}" "$FORTUNE_PATH"
) ; fi

