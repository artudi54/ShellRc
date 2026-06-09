#!/usr/bin/env bash
# extract — unpack archives to an optional destination directory
# Usage: extract <archive> [destination]

if [[ $# -lt 1 ]]; then
    echo "Usage: $(basename "$0") <archive> [destination]" >&2
    exit 1
fi

if [[ ! -f "$1" ]]; then
    echo "error: '$1' is not a valid file" >&2
    exit 1
fi

DEST="${2:-.}"
mkdir -p "$DEST" || { echo "error: cannot create destination '$DEST'" >&2; exit 1; }

# Resolve to absolute path so cd-based tools (rpm) work correctly
SRC="$(realpath "$1")"

case "$1" in
    # --- tar family ---
    *.tar)                         tar xf   "$SRC" -C "$DEST" ;;
    *.tar.bz2|*.tbz2)              tar xjf  "$SRC" -C "$DEST" ;;
    *.tar.gz|*.tgz)                tar xzf  "$SRC" -C "$DEST" ;;
    *.tar.xz|*.txz)                tar xJf  "$SRC" -C "$DEST" ;;
    *.tar.zst|*.tzst)              tar --zstd -xf "$SRC" -C "$DEST" ;;
    *.tar.lz4)                     lz4 -dc "$SRC" | tar xf - -C "$DEST" ;;
    *.tar.lzma)                    tar --lzma  -xf "$SRC" -C "$DEST" ;;
    *.tar.lz)                      tar --lzip  -xf "$SRC" -C "$DEST" ;;

    # --- single-stream compressors (output: filename minus extension) ---
    *.bz2)   bunzip2 -c             "$SRC" > "$DEST/$(basename "${1%.bz2}")"  ;;
    *.gz)    gunzip  -c             "$SRC" > "$DEST/$(basename "${1%.gz}")"   ;;
    *.xz)    xz      -dc            "$SRC" > "$DEST/$(basename "${1%.xz}")"   ;;
    *.zst)   zstd    -d --keep      "$SRC" -o "$DEST/$(basename "${1%.zst}")" ;;
    *.lz4)   lz4     -dk            "$SRC"    "$DEST/$(basename "${1%.lz4}")" ;;
    *.lzma)  xz --format=lzma -dc   "$SRC" > "$DEST/$(basename "${1%.lzma}")" ;;
    *.lz)    lzip    -dc            "$SRC" > "$DEST/$(basename "${1%.lz}")"   ;;
    *.Z)     uncompress -c          "$SRC" > "$DEST/$(basename "${1%.Z}")"    ;;

    # --- archive formats ---
    *.zip|*.jar|*.war|*.ear|*.apk|*.aar)
             unzip      "$SRC" -d "$DEST"  ;;
    *.rar)   unrar e    "$SRC"    "$DEST/" ;;
    *.7z)    7z x       "$SRC" -o"$DEST"  ;;
    *.iso)   7z x       "$SRC" -o"$DEST"  ;;
    *.cab)   cabextract -d "$DEST" "$SRC" ;;

    # --- package formats ---
    *.deb)   dpkg-deb -x "$SRC" "$DEST" ;;
    *.rpm)   (cd "$DEST" && rpm2cpio "$SRC" | cpio -idmv) ;;

    *)       echo "error: '$1' cannot be extracted" >&2; exit 1 ;;
esac
