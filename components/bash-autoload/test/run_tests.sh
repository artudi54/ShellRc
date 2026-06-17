#!/usr/bin/env bash
# Test harness for bash-autoload component

set -o pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMPONENT_DIR="$(dirname "$SCRIPT_DIR")"
SHELLRC_DIR="$(dirname "$(dirname "$COMPONENT_DIR")")"

__test_passed=0
__test_failed=0
__test_total=0

assert_eq() {
    local desc="$1" expected="$2" actual="$3"
    (( __test_total++ )) || true || true
    if [[ "$expected" == "$actual" ]]; then
        (( __test_passed++ )) || true || true
        echo "  ✓ $desc"
    else
        (( __test_failed++ )) || true
        echo "  ✗ $desc"
        echo "    expected: $(printf '%q' "$expected")"
        echo "    actual:   $(printf '%q' "$actual")"
    fi
}

assert_match() {
    local desc="$1" pattern="$2" actual="$3"
    (( __test_total++ )) || true
    if [[ "$actual" =~ $pattern ]]; then
        (( __test_passed++ )) || true
        echo "  ✓ $desc"
    else
        (( __test_failed++ )) || true
        echo "  ✗ $desc"
        echo "    pattern:  $pattern"
        echo "    actual:   $(printf '%q' "$actual")"
    fi
}

assert_exit() {
    local desc="$1" expected="$2" actual="$3"
    (( __test_total++ )) || true
    if [[ "$expected" -eq "$actual" ]]; then
        (( __test_passed++ )) || true
        echo "  ✓ $desc"
    else
        (( __test_failed++ )) || true
        echo "  ✗ $desc"
        echo "    expected exit: $expected"
        echo "    actual exit:   $actual"
    fi
}

run_test_suite() {
    local suite="$1"
    local test_file="$SCRIPT_DIR/$suite"

    if [[ ! -f "$test_file" ]]; then
        echo "ERROR: test file not found: $test_file" >&2
        return 1
    fi

    echo ""
    echo "━━━ $suite ━━━"
    source "$test_file"
}

# Bootstrap: load dependencies and bash-autoload
source "$SHELLRC_DIR/components/script-sourcing/script-sourcing.sh"
source "$SHELLRC_DIR/components/shellrc-hooks/shellrc-hooks.sh"
source "$SHELLRC_DIR/components/bash-bound-vars/bash-bound-vars.sh"
source "$COMPONENT_DIR/bash-autoload.sh"

# Run all test suites
for suite in "$SCRIPT_DIR"/test_*.sh; do
    run_test_suite "$(basename "$suite")"
done

# Summary
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Total:  $__test_total"
echo "  Passed: $__test_passed"
echo "  Failed: $__test_failed"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

[[ "$__test_failed" -eq 0 ]]
