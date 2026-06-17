# Test: +X (immediate load) and -X (in-place autoload)

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' RETURN
FPATH="$tmpdir"

# --- +X loads without executing ---

printf 'echo "loaded immediately"\n' > "$tmpdir/immediate"
autoload +X immediate
assert_eq "+X loads function" "loaded immediately" "$(immediate)"

# registry should show loaded
local state="${__autoload_registry[immediate]:-}"
assert_eq "+X sets registry to loaded" "loaded" "$state"

# --- +X with multiple names ---

printf 'echo "ia"\n' > "$tmpdir/imm_a"
printf 'echo "ib"\n' > "$tmpdir/imm_b"
autoload +X imm_a imm_b
assert_eq "+X multi: first" "ia" "$(imm_a)"
assert_eq "+X multi: second" "ib" "$(imm_b)"

# --- +X with missing function errors ---

autoload +X nonexistent_imm 2>/dev/null; local rc=$?
assert_exit "+X with missing function errors" 1 "$rc"

# --- -X inside manually written stub ---

printf 'echo "resolved: $1"\n' > "$tmpdir/manual_stub_fn"
manual_stub_fn() { autoload -X && manual_stub_fn "$@"; }
assert_eq "-X resolves and re-invokes" "resolved: hello" "$(manual_stub_fn hello)"

# --- -X preserves flags ---

printf 'echo "flagged: $1"\n' > "$tmpdir/flagged_stub"
__autoload_flags[flagged_stub]="U"
flagged_stub() { autoload -X && flagged_stub "$@"; }
assert_eq "-X preserves stored flags" "flagged: test" "$(flagged_stub test)"

# --- -X outside function errors ---

local out
out="$(autoload -X 2>&1)"; local rc2=$?
assert_exit "-X outside function errors" 1 "$rc2"
assert_match "-X error message" "must be used inside a function" "$out"
