# Command completion for extract
[[ $- != *i* ]] && return

_extract_extensions=(
    tar tar.bz2 tbz2 tar.gz tgz tar.xz txz tar.zst tzst tar.lz4 tar.lzma tar.lz
    bz2 gz xz zst lz4 lzma lz z
    zip jar war ear apk aar
    rar 7z iso cab
    deb rpm
)

if [[ -v BASH_VERSION ]]; then
    _extract() {
        COMPREPLY=()
        case "$COMP_CWORD" in
            1)
                # Complete archive files by extension
                local IFS=$'\n'
                local exts=""
                for ext in "${_extract_extensions[@]}"; do
                    exts+=" -e $ext"
                done
                COMPREPLY=($(compgen -f -- "${COMP_WORDS[1]}"))
                # Filter to only matching archive extensions
                local filtered=()
                for item in "${COMPREPLY[@]}"; do
                    if [[ -d "$item" ]]; then
                        filtered+=("$item/")
                    else
                        local lower="${item,,}"
                        for ext in "${_extract_extensions[@]}"; do
                            if [[ "$lower" == *."$ext" ]]; then
                                filtered+=("$item")
                                break
                            fi
                        done
                    fi
                done
                COMPREPLY=("${filtered[@]}")
                ;;
            2)
                # Complete destination directory
                COMPREPLY=($(compgen -d -- "${COMP_WORDS[2]}"))
                ;;
        esac
    }
    complete -o filenames -F _extract extract

elif [[ -v ZSH_VERSION ]]; then
    _extract() {
        local -a archive_globs=()
        for ext in "${_extract_extensions[@]}"; do
            archive_globs+=("*.$ext")
        done
        local glob_pattern="(${(j:|:)archive_globs})"

        _arguments \
            '1:archive:_files -g "'"$glob_pattern"'"' \
            '2:destination:_directories'
    }
    compdef _extract extract
fi
