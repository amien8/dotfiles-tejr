" .xinitrc is a shell script
autocmd BufNewFile,BufRead
    \ .xinitrc
    \ setlocal filetype=sh

" Edited bash command lines are shell script
autocmd BufNewFile,BufRead
    \ bash-fc-*
    \ let g:is_bash = 1 |
    \ setlocal filetype=sh

" Files in /etc/default are shell script
autocmd BufNewFile,BufRead
    \ /etc/default/*
    \ setlocal filetype=sh

