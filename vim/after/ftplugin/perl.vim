" Run perl -c on the current buffer
nnoremap <leader>pc :!perl -c %<CR>

" Run perlcritic over the current buffer
nnoremap <leader>pl :!perlcritic %<CR>

" Run the current buffer through perltidy
nnoremap <leader>pt :%!perltidy<CR>

