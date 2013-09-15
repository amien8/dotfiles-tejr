# Print a terminal bell; good for the end of long commands to prompt me into
# looking at the window:
#
# $ long-boring-command ; bell
#
bell() {
    printf %s $'\a'
}

