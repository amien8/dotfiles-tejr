# builtin with builtins
complete -b builtin

# cd/pushd with directories
complete -d cd pushd

# command/hash/type with commands
complete -c command hash type

# help with topics
complete -A helptopic help

# set with options
complete -A setopt set

# shopt with shell options
complete -A shopt shopt

# unset with shell variables and functions
complete -v -A function unset

