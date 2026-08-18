#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
PKG="phase4_orchestrator"

echo
echo "==============================================="
echo "Running Negative Suite"
echo "Package : $PKG"
echo "==============================================="

(
    cd "$PKG_ROOT"
    nargo compile
)

for VECTOR in "$PKG_ROOT/tests/negative"/*.toml
do
    NAME="$(basename "$VECTOR")"

    echo
    echo ">>> $NAME"

    grep -v '^return[[:space:]]*=' "$VECTOR" > "$PKG_ROOT/Prover.toml"

    LOG_FILE="$(mktemp)"

    if (
        cd "$PKG_ROOT"
        nargo execute >"$LOG_FILE" 2>&1
    ); then
        echo "FAIL (unexpectedly succeeded)"
        cat "$LOG_FILE"
        rm -f "$LOG_FILE"
        exit 1
    elif grep -q "Failed constraint" "$LOG_FILE"; then
        echo "PASS (expected constraint failure)"
    else
        echo "FAIL (execution, parsing, or toolchain error)"
        cat "$LOG_FILE"
        rm -f "$LOG_FILE"
        exit 1
    fi

    rm -f "$LOG_FILE"
done

echo
echo "==============================================="
echo "ALL NEGATIVE TESTS PASSED"
echo "==============================================="
