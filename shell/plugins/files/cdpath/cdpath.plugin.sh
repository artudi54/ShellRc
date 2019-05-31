# plugin that enables jumping into directories fast

if [ -n "$ZSH_VERSION" ]; then
    setopt autocd
fi


cdpath() {
    echo "$CDPATH"
}

cdpath-show() {
    echo -e ${CDPATH//:/\\n}
}

cdpath-contains() {
    if [ "$#" -ne 1 ]; then
        echo "cdpath: invalid number of arguments" 1>&2
        return 2
    fi

    local checkDir="$(readlink -f "$1")"
    local dirsArray
    IFS=$'\n' dirsArray=($(cdpath-show))
    for dir in "${dirsArray[@]}"; do
        if [ "$checkDir" = "$dir" ]; then
            return 0
        fi
    done
    return 1
}

cdpath-clear() {
    unset CDPATH
    shellrc-conf-unset CDPATH
}

cdpath-add() {
    if [ "$#" -ge 2 ]; then
        echo "cdpath: invalid number of arguments" 1>&2
        return 1
    fi

    local dirpath
    if [ "$#" -eq 0 ]; then
        dirpath="."
    else
        dirpath="$1"
    fi
    dirpath="$(readlink -f "$dirpath")"

    if cdpath-contains "$dirpath"; then
        return 0
    fi

    if [ -z "$CDPATH" ]; then
        CDPATH="$dirpath"
    else
        CDPATH="$CDPATH:$dirpath"
    fi
    shellrc-conf-set "CDPATH" "$CDPATH"
}

cdpath-remove() {
    if [ "$#" -ne 1 ]; then
        echo "cdpath: invalid number of arguments" 1>&2
        return 1
    fi
    
    local removeDir="$(readlink -f "$1")"
    local dirsArray
    IFS=$'\n' dirsArray=($(cdpath-show))
    cdpath-clear
    for dir in "${dirsArray[@]}"; do
        if [ "$removeDir" != "$dir" ]; then
            cdpath-add "$dir"
        fi
    done
}
