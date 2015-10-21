" .xinitrc is a shell script
autocmd BufNewFile,BufRead
    \ .xinitrc
    \ setlocal filetype=sh

" Files in /etc/default are shell script
autocmd BufNewFile,BufRead
    \ /etc/default/*
    \ setlocal filetype=sh

" Files in **/.dotfiles/sh/** are shell script
autocmd BufNewFile,BufRead
    \ **/.dotfiles/sh/**
    \ setlocal filetype=sh

" Edited bash command lines are Bash script
autocmd BufNewFile,BufRead
    \ bash-fc-*
    \ let g:is_bash = 1 |
    \ setlocal filetype=sh

" Files in **/.dotfiles/bash/** are Bash script
autocmd BufNewFile,BufRead
    \ **/.dotfiles/bash/**
    \ let g:is_bash = 1 |
    \ setlocal filetype=sh

