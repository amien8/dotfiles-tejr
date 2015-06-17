" Run tidy -eq -utf8 on file for the current buffer
nnoremap <leader>v :exe "!tidy -eq -utf8 " . shellescape(expand("%"))<CR>

" Make a bare URL into a link to itself
function! UrlLink()
  normal ByE
  execute "normal i<a href=\"\<C-R>0\">\<Esc>"
  normal E
  execute "normal a</a>\<Esc>"
endfunction
nnoremap <silent> <leader>r :<C-U>call UrlLink()<CR>

