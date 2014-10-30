" .xsession and .xsessionrc are shell scripts
autocmd BufNewFile,BufRead
    \ .xsession,.xsessionrc
    \ setlocal filetype=sh

