" shDerefSimple in sh.vim is not quite right, so let's fix it up
syntax clear shDerefSimple

" $var, $VAR, $var_new, $_var, $var1 ...
syntax match shDerefSimple '\$\h[a-zA-Z0-9_]*'
" $0, $1, $2 ...
syntax match shDerefSimple '\$\d'
" $-, $#, $* ...
syntax match shDerefSimple '\$[-#*@!?$]'

