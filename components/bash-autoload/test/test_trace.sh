# Test: -t/-T (trace) flag

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' RETURN
FPATH="$tmpdir"

# --- -t sets trace attribute ---

printf 'echo "traced"\n' > "$tmpdir/traced_fn"
autoload -t +X traced_fn
local attrs
attrs="$(declare -pF traced_fn)"
assert_match "-t sets trace attribute" "traced_fn" "$attrs"

# Verify the trace flag is present via declare -pf
local pf
pf="$(declare -pf traced_fn 2>&1)"
# declare -ft means trace is set
assert_match "-t: declare shows -ft" "declare -ft traced_fn" "$(declare -pF traced_fn 2>&1 || true)"

assert_eq "-t function still runs" "traced" "$(traced_fn)"

# --- -T behaves same as -t ---

printf 'echo "traced_T"\n' > "$tmpdir/traced_T"
autoload -T +X traced_T
assert_match "-T sets trace attribute" "declare -ft traced_T" "$(declare -pF traced_T 2>&1 || true)"
assert_eq "-T function still runs" "traced_T" "$(traced_T)"

# --- -t combined with other flags ---

printf 'echo "tc"\n' > "$tmpdir/trace_combo"
autoload -Ut +X trace_combo
assert_match "-Ut combined: trace set" "declare -ft trace_combo" "$(declare -pF trace_combo 2>&1 || true)"
assert_eq "-Ut combined: function runs" "tc" "$(trace_combo)"
