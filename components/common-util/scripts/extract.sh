#!/usr/bin/env bash
# extract — unpack archives to an optional destination directory
# Usage: extract <archive> [destination]

set -o pipefail
# shellcheck disable=SC2155 # local var assignment in subshells is fine here

if [[ $# -lt 1 ]]; then
    echo "Usage: $(basename "$0") <archive> [destination]" >&2
    exit 1
fi

ARCHIVE="$1"
if [[ ! -f "$ARCHIVE" ]]; then
    echo "error: '$ARCHIVE' is not a valid file" >&2
    exit 1
fi

DEST="${2:-.}"
mkdir -p "$DEST" || { echo "error: cannot create destination '$DEST'" >&2; exit 1; }

# Resolve to absolute path so cd-based tools (rpm) work correctly
SRC="$(realpath "$ARCHIVE")"

FNAME="$(basename "$SRC")"
# lowercase filename for case-insensitive matching
LCASE="${FNAME,,}"

need() {
    for cmd in "$@"; do
        command -v "$cmd" >/dev/null 2>&1 || { echo "error: required command '$cmd' not found" >&2; exit 1; }
    done
}

case "$LCASE" in
    # --- tar family ---
    *.tar)                         need tar; tar xf   "$SRC" -C "$DEST" ;;
    *.tar.bz2|*.tbz2)              need tar; tar xjf  "$SRC" -C "$DEST" ;;
    *.tar.gz|*.tgz)                need tar; tar xzf  "$SRC" -C "$DEST" ;;
    *.tar.xz|*.txz)                need tar; tar xJf  "$SRC" -C "$DEST" ;;
    *.tar.zst|*.tzst)              need tar; tar --zstd -xf "$SRC" -C "$DEST" ;;
    *.tar.lz4)                     need lz4 tar; lz4 -dc "$SRC" | tar xf - -C "$DEST" ;;
    *.tar.lzma)                    need tar; tar --lzma  -xf "$SRC" -C "$DEST" ;;
    *.tar.lz)                      need tar; tar --lzip  -xf "$SRC" -C "$DEST" ;;

    # --- single-stream compressors (output: filename minus extension) ---
    *.bz2)   need bunzip2;   bunzip2 -c  "$SRC" > "$DEST/${FNAME%.bz2}" ;;
    *.gz)    need gunzip;    gunzip -c   "$SRC" > "$DEST/${FNAME%.gz}" ;;
    *.xz)    need xz;        xz -dc      "$SRC" > "$DEST/${FNAME%.xz}" ;;
    *.zst)   need zstd;      zstd -dc    "$SRC" > "$DEST/${FNAME%.zst}" ;;
    *.lz4)   need lz4;       lz4 -dc     "$SRC" > "$DEST/${FNAME%.lz4}" ;;
    *.lzma)  need xz;        xz --format=lzma -dc "$SRC" > "$DEST/${FNAME%.lzma}" ;;
    *.lz)    need lzip;      lzip -dc    "$SRC" > "$DEST/${FNAME%.lz}" ;;
    *.z)     need uncompress; uncompress -c "$SRC" > "$DEST/${FNAME%.Z}" ;;

    # --- archive formats ---
    *.zip|*.jar|*.war|*.ear|*.apk|*.aar)
             need unzip; unzip -q "$SRC" -d "$DEST" ;;
    *.rar)   need unrar; unrar x "$SRC" "$DEST/" ;;
    *.7z)    need 7z; 7z x -y "$SRC" -o"$DEST" >/dev/null ;;
    *.iso)   need 7z; 7z x -y "$SRC" -o"$DEST" >/dev/null ;;
    *.cab)   need cabextract; cabextract -d "$DEST" "$SRC" ;;

    # --- package formats ---
    *.deb)   need dpkg-deb; dpkg-deb -x "$SRC" "$DEST" ;;
    *.rpm)   need rpm2cpio cpio; (cd "$DEST" && rpm2cpio "$SRC" | cpio -idmv) ;;

    *)       echo "error: '$ARCHIVE' cannot be extracted" >&2; exit 1 ;;
esac

