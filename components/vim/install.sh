dir="$(script_directory)"

has() {
    command -v "$1" &>/dev/null
}

#ycm
args=(--go-completer --clangd-completer)
has mcs || has dotnet && args+=(--cs-completer)
has javac             && args+=(--java-completer)
has node && has npm   && args+=(--ts-completer)
has cargo             && args+=(--rust-completer)
python3 "$dir/plugins/YouCompleteMe/install.py" "${args[@]}"

