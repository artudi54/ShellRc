# Test: -k (ksh-style) flag

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' RETURN
FPATH="$tmpdir"

# --- -k loads function-definition files normally ---

printf 'ksh_def() { echo "ksh defined: $1"; }\n' > "$tmpdir/ksh_def"
autoload -k ksh_def
assert_eq "-k loads func-def file" "ksh defined: ok" "$(ksh_def ok)"

# --- -k rejects body-only files ---

printf 'echo "body only"\n' > "$tmpdir/ksh_body"
autoload -k ksh_body
local out
out="$(ksh_body 2>&1)"; local rc=$?
assert_exit "-k rejects body-only" 1 "$rc"
assert_match "-k error mentions ksh" "ksh-style" "$out"

# --- -k combined with -U ---

printf 'ksh_u() { echo "ksh-U: $1"; }\n' > "$tmpdir/ksh_u"
autoload -kU ksh_u
assert_eq "-kU combined works" "ksh-U: test" "$(ksh_u test)"

# --- -k overrides -z ---

printf 'echo "should fail"\n' > "$tmpdir/kz_test"
autoload -kz kz_test
local out2
out2="$(kz_test 2>&1)"; local rc2=$?
assert_exit "-k overrides -z (rejects body-only)" 1 "$rc2"
