dir="$(script_directory)"
mkdir -p "$XDG_CONFIG_HOME/git"
printf "[include]\tpath = \"$dir/gitconfig.ini\"\n" >"$XDG_CONFIG_HOME/git/config"
touch "$XDG_CONFIG_HOME/git/credentials"

IFS=$'\n' read -p "Enter your name: " name
read -p "Enter your email: " email

git config --global include.path "$dir/gitconfig.ini"
git config --global user.name "$name"
git config --global user.email "$email"
git config --local include.path ../.gitconfig

mkdir -p "$dir/bin"
mkdir -p "$dir/man/man"{1..8}
mkdir -p "$dir/completions/"{bash,zsh}

(cd "$dir/lib/git-flow-next" && ./scripts/build.sh)
mv "$dir/lib/git-flow-next/dist/git-flow-dev-linux-amd64" "$dir/bin/git-flow"

"$dir/bin/git-flow" completion bash > "$dir/completions/bash/_git-flow"
"$dir/bin/git-flow" completion zsh > "$dir/completions/zsh/_git-flow"

# Add a small wrapper to the bash completion so `git flow ...` (two-word form)
# uses the same completion logic as the `git-flow` binary.
cat >> "$dir/completions/bash/_git-flow" <<'EOF'

_git_flow() {
    local old_words=("${COMP_WORDS[@]}")
    local old_cword=$COMP_CWORD
    local old_line=$COMP_LINE
    local old_point=$COMP_POINT

    local after="${COMP_LINE#git*flow }"
    local old_prefix_len=$(( ${#COMP_LINE} - ${#after} ))
    local new_prefix_len=9  # length of "git-flow "

    COMP_WORDS=("git-flow" "${COMP_WORDS[@]:2}")
    COMP_CWORD=$(( COMP_CWORD - 1 ))
    COMP_LINE="git-flow ${after}"
    COMP_POINT=$(( COMP_POINT - old_prefix_len + new_prefix_len ))

    __start_git-flow "$@"

    COMP_WORDS=("${old_words[@]}")
    COMP_CWORD=$old_cword
    COMP_LINE=$old_line
    COMP_POINT=$old_point
}

EOF

sed -i 's/\b_git-flow\b/__git-flow_complete/g' "$dir/completions/zsh/_git-flow"
cat >> "$dir/completions/zsh/_git-flow" <<'EOF'

_git-flow() {
    words[1]="git-flow"
    __git-flow_complete "$@"
}

EOF

find "$dir/lib/git-flow-next/docs" -type f -name '*.[0-9].md' | while read -r src; do
    filename=$(basename "$src")
    base=${filename%.md}
    section=${base##*.}
    pandoc -s -t man "$src" -o "$dir/man/man${section}/${filename%.md}"
done


(cd "$dir/lib/git-extras" && PREFIX="$dir/install" make install)
mv "$dir/install/bin"/* "$dir/bin"
ln -s "$dir/lib/git-extras/man"/*.1 "$dir/man/man1"
ln -s "$dir/lib/git-extras/etc/bash_completion.sh" "$dir/completions/bash/_git-extras"
ln -s "$dir/lib/git-extras/etc/git-extras-completion.zsh" "$dir/completions/zsh/_git-extras"
rm -rf "$dir/install"


ln -s "$dir/lib/git-utils/bin"/* "$dir/bin"
ln -s "$dir/lib/git-utils/man/man1"/* "$dir/man/man1"
ln -s "$dir/lib/git-utils/completions/bash"/* "$dir/completions/bash"
ln -s "$dir/lib/git-utils/completions/zsh"/* "$dir/completions/zsh"

