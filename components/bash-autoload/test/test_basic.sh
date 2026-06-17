# Test: basic autoloading — zsh-style (body and func-def) and ksh-style

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' RETURN
FPATH="$tmpdir"

# --- zsh-style: pure body file ---

printf 'echo "hello $1"\n' > "$tmpdir/greet"
autoload greet
assert_eq "body format loads and runs" "hello world" "$(greet world)"

# --- zsh-style: file with function definition gets sourced ---

printf 'greet_def() { echo "def $1"; }\n' > "$tmpdir/greet_def"
autoload greet_def
assert_eq "func-def file sourced in -z mode" "def world" "$(greet_def world)"

# --- ksh-style (-k): file sources, must define function ---

printf 'greet_k() { echo "hello $1"; }\n' > "$tmpdir/greet_k"
autoload -k greet_k
assert_eq "ksh-style func-def loads and runs" "hello world" "$(greet_k world)"

# --- multi-line body ---

printf 'local x=$1\nlocal y=$2\necho "product: $(( x * y ))"\n' > "$tmpdir/mul"
autoload mul
assert_eq "multi-line body works" "product: 30" "$(mul 5 6)"

# --- second call uses loaded function ---

assert_eq "second call to body func works" "hello again" "$(greet again)"
assert_eq "second call to ksh func works" "hello again" "$(greet_k again)"

# --- body function with no arguments ---

printf 'echo "no args"\n' > "$tmpdir/noargs"
autoload noargs
assert_eq "no-argument function works" "no args" "$(noargs)"

# --- function returning exit code ---

printf 'return 42\n' > "$tmpdir/retcode"
autoload retcode
retcode 2>/dev/null; local rc=$?
assert_exit "function exit code is preserved" 42 "$rc"

# --- function with special characters in output ---

printf 'echo "tab\there newline"\n' > "$tmpdir/special"
autoload special
assert_match "special chars in output" "tab.*here newline" "$(special)"

# --- body function using local variables ---

printf 'local x="local_val"\necho "$x"\n' > "$tmpdir/localvars"
autoload localvars
assert_eq "local variables work" "local_val" "$(localvars)"

# --- multiple functions autoloaded at once ---

printf 'echo "a"\n' > "$tmpdir/multi_a"
printf 'echo "b"\n' > "$tmpdir/multi_b"
printf 'echo "c"\n' > "$tmpdir/multi_c"
autoload multi_a multi_b multi_c
assert_eq "multi autoload: first" "a" "$(multi_a)"
assert_eq "multi autoload: second" "b" "$(multi_b)"
assert_eq "multi autoload: third" "c" "$(multi_c)"
