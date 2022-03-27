# plugin for showing command information in shell


# debian based
if [ -x /usr/lib/command-not-found -o -x /usr/share/command-not-found/command-not-found ]; then
    command_not_found_handle() {
        if [ -x /usr/lib/command-not-found ]; then
            /usr/lib/command-not-found -- "$1"
            return $?
        elif [ -x /usr/share/command-not-found/command-not-found ]; then
            /usr/share/command-not-found/command-not-found -- "$1"
            return $?
        else
           printf "%s: command not found\n" "$1" >&2
           return 127
        fi
    }
    command_not_found_handler() {
        command_not_found_handle "$@"
    }

# arch based
elif [[ -f /usr/share/doc/pkgfile/command-not-found.bash ]]; then
    if [ -n "$BASH_VERSION" ]; then
        source /usr/share/doc/pkgfile/command-not-found.bash
    elif [ -n "$ZSH_VERSION" ]; then
        source /usr/share/doc/pkgfile/command-not-found.zsh
    fi
fi

