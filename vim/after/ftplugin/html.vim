" Make a bare URL into a link to itself
function! UrlLink()
  normal ByE
  execute "normal i<a href=\"\<C-R>0\">\<Esc>"
  normal E
  execute "normal a</a>\<Esc>"
endfunction
nnoremap <silent> <leader>r :<C-U>call UrlLink()<CR>

