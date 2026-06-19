#!/usr/bin/env bash
set -e

image="$1"
name="${image##*:}"

log_dir="${SHELLRC_CACHE_DIR:-${XDG_CACHE_HOME:-$HOME/.cache}/ShellRc}/test-logs"
mkdir -p "$log_dir"
timestamp=$(date +%Y%m%d-%H%M%S)
log_file="$log_dir/${name}_${timestamp}.log"

printf "Testing %-20s" "$name..."

start=$(date +%s)
if script -qec "docker run --rm $image" "$log_file" >/dev/null 2>&1; then
    end=$(date +%s)
    printf " OK (%ds)\n" "$(( end - start ))"
else
    rc=$?
    end=$(date +%s)
    printf " FAILED (%ds, exit %d)\n" "$(( end - start ))" "$rc"
    echo "--- log: $log_file ---"
    cat "$log_file"
    exit "$rc"
fi
