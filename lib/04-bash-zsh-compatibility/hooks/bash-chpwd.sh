# chpwd hook

# source file only once 
if [ "$__chpwd_imported" = "defined" ]; then
    return 0
fi
__chpwd_imported="defined"


# hook calling functions
__chpwd_hook() {
    local __chpwd_inside_hook
    # block recursive call to hook
    if [ "$__chpwd_inside_hook" = "defined" ]; then
        return
    fi
    __chpwd_inside_hook="defined"

    local trimmed_command
    if type -t "chpwd" 1>/dev/null; then
        chpwd
    fi

    local fun
    for fun in ${chpwd_functions[@]}; do
        if type -t "$fun" 1>/dev/null; then
            $fun
        fi
    done
}

# initialize chpwd variable
__chpwd_init() {
    chpwd_functions=()
}


# builtins override
cd() { builtin cd "$@" && __chpwd_hook; }
pushd() { builtin pushd "$@" && __chpwd_hook; }
popd() { builtin popd "$@" && __chpwd_hook; }


__chpwd_init
