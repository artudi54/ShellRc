# Utilities with desktop entries

autoload -Uz array-append-unique
array-append-unique path "$(script_directory)/bin"

case ":$XDG_DATA_DIRS:" in
    *":$dir:"*) ;;
    *) export XDG_DATA_DIRS="$XDG_DATA_DIRS:$(script_directory)" ;;
esac

