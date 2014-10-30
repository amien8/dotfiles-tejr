" shDerefSimple in sh.vim is not quite right, so let's fix it up
syntax clear shDerefSimple

" $var, $VAR, $var_new, $_var, $var1 ...
syntax match shDerefSimple '\$\h[a-zA-Z0-9_]*'
" $0, $1, $2 ...
syntax match shDerefSimple '\$\d'
" $-, $#, $* ...
syntax match shDerefSimple '\$[-#*@!?$]'

" Trust me to get my dereferencing right
syntax clear shDerefWordError

" I don't like having 'restart', 'start" etc highlighted
syntax clear bashAdminStatement

" Limit bashStatement only to alphanumeric shell builtins
syntax clear bashStatement
syntax keyword bashStatement
    \ alias
    \ bg
    \ bind
    \ break
    \ builtin
    \ caller
    \ cd
    \ command
    \ compgen
    \ complete
    \ compopt
    \ continue
    \ declare
    \ dirs
    \ disown
    \ echo
    \ enable
    \ eval
    \ exec
    \ exit
    \ export
    \ false
    \ fc
    \ fg
    \ getopts
    \ hash
    \ help
    \ history
    \ jobs
    \ kill
    \ let
    \ local
    \ logout
    \ mapfile
    \ popd
    \ printf
    \ pushd
    \ pwd
    \ read
    \ readarray
    \ readonly
    \ return
    \ set
    \ shift
    \ shopt
    \ source
    \ suspend
    \ test
    \ times
    \ trap
    \ true
    \ type
    \ typeset
    \ ulimit
    \ umask
    \ unalias
    \ unset
    \ wait

