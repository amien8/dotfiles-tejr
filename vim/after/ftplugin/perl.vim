" Run perl -c on file for the current buffer
nnoremap <leader>pc :exe "!perl -c " . shellescape(expand("%"))<CR>
" Run perlcritic on the file for the current buffer
nnoremap <leader>pl :exe "!perlcritic " . shellescape(expand("%"))<CR>
" Run the current buffer through perltidy
nnoremap <leader>pt :%!perltidy<CR>

