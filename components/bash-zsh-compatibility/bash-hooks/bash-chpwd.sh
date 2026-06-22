# chpwd hook
[[ $- != *i* ]] && return

# source file only once 
if [ "$__chpwd_imported" = "defined" ]; then
    return 0
fi
__chpwd_imported="defined"


# hook calling functions
__chpwd_hook() {
    [ "$__chpwd_inside_hook" = "defined" ] && return
    __chpwd_inside_hook="defined"
    trap 'unset __chpwd_inside_hook' RETURN

    if declare -f "chpwd" >/dev/null 2>&1; then
        chpwd
    fi

    local fun
    for fun in "${chpwd_functions[@]}"; do
        if declare -f "$fun" >/dev/null 2>&1; then
            "$fun"
        fi
    done
}

# builtins override
cd() {
    builtin cd "$@"
    local ret=$?
    (( ret == 0 && BASH_SUBSHELL == 0 )) && __chpwd_hook
    return $ret;
}
pushd() {
    builtin pushd "$@"
    local ret=$?
    (( ret == 0 && BASH_SUBSHELL == 0 )) && __chpwd_hook
    return $ret
}
popd() {
    builtin popd "$@"
    local ret=$?
    (( ret == 0 && BASH_SUBSHELL == 0 )) && __chpwd_hook
    return $ret
}

# initialize chpwd hook list
declare -ga chpwd_functions

