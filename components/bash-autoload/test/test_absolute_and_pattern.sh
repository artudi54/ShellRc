# Test: absolute path autoloading and -m pattern with +X

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' RETURN
FPATH="$tmpdir"

# --- absolute path: function named after basename ---

printf 'echo "abs loaded"\n' > "$tmpdir/abs_fn"
autoload "$tmpdir/abs_fn"
assert_eq "absolute path registers function" "abs loaded" "$(abs_fn)"

# --- absolute path with -d falls back to FPATH ---

printf 'echo "fallback"\n' > "$tmpdir/fallback_fn"
autoload -d "/nonexistent/path/fallback_fn"
assert_eq "-d falls back to FPATH" "fallback" "$(fallback_fn)"

# --- +X with -m: load already-registered matching pattern ---

printf 'echo "pa"\n' > "$tmpdir/pat_alpha"
printf 'echo "pb"\n' > "$tmpdir/pat_beta"
printf 'echo "other"\n' > "$tmpdir/other_fn"
autoload pat_alpha pat_beta other_fn

# Only load pat_* functions
autoload -m +X 'pat_*'
local state_a="${__autoload_registry[pat_alpha]:-}"
local state_b="${__autoload_registry[pat_beta]:-}"
local state_o="${__autoload_registry[other_fn]:-}"
assert_eq "-m +X loads matching: alpha" "loaded" "$state_a"
assert_eq "-m +X loads matching: beta" "loaded" "$state_b"
assert_eq "-m +X skips non-matching" "undefined" "$state_o"

# Functions still work
assert_eq "-m +X loaded function runs" "pa" "$(pat_alpha)"
assert_eq "-m +X loaded function runs" "pb" "$(pat_beta)"
