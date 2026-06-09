if [[ "$PATH" != *"$(script_directory)/bin"* ]]; then
    export PATH="$PATH:$(script_directory)/bin"
fi
