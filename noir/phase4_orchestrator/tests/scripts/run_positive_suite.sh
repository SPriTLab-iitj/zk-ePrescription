#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
REPO_ROOT="$(cd "$PKG_ROOT/.." && pwd)"
PKG="phase4_orchestrator"

echo
echo "==============================================="
echo "Running Positive Suite"
echo "Package : $PKG"
echo "==============================================="

(
    cd "$PKG_ROOT"
    nargo compile
)

for VECTOR in "$PKG_ROOT/tests/positive"/*.toml
do
    NAME="$(basename "$VECTOR")"

    echo
    echo ">>> $NAME"

    grep -v '^return[[:space:]]*=' "$VECTOR" > "$PKG_ROOT/Prover.toml"

    (
        cd "$PKG_ROOT"
        nargo execute > /dev/null
    )

    (
        cd "$PKG_ROOT"
        bb prove \
            -b target/${PKG}.json \
            -w target/${PKG}.gz \
            --write_vk \
            -o target \
            >/dev/null

        bb verify \
            -k target/vk \
            -p target/proof \
            >/dev/null
    )

    echo "PASS"
done

echo
echo "==============================================="
echo "ALL POSITIVE TESTS PASSED"
echo "==============================================="
