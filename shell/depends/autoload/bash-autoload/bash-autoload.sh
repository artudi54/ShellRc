# autoload support for bash like zsh

_autoloaded=()

_print_function() {
    type $1 | tail -n +2
}

_autoload_print() {
    for fun in ${_autoloaded[@]}; do
        _print_function "$fun"
    done
}

autoload() {
    if [ "$#" -eq 0 ]; then
        _autoload_print
        return
    fi
}



