#!/usr/bin/env bash
set -e

ROOT="$HOME/zk-ePrescription/noir"
PKG="phase4_orchestrator"

echo
echo "==============================================="
echo "Running Negative Suite"
echo "Package : $PKG"
echo "==============================================="

# Compile once
(
    cd "$ROOT"
    nargo compile --package "$PKG"
)

for VECTOR in "$ROOT/$PKG/tests/negative"/*.toml
do
    NAME=$(basename "$VECTOR")

    echo
    echo ">>> $NAME"

    # Strip return field for nargo execute to pass natively and save to Prover.toml
    grep -v "return" "$VECTOR" > "$ROOT/$PKG/Prover.toml"

    # We expect nargo execute to FAIL due to constraint violations.
    # We capture the exit status.
    set +e
    (
        cd "$ROOT/$PKG"
        nargo execute > /dev/null 2>&1
    )
    STATUS=$?
    set -e

    if [ $STATUS -eq 0 ]; then
        echo "FAIL: Expected constraint failure, but execution succeeded for $NAME"
        exit 1
    else
        echo "PASS (correctly failed with constraint error)"
    fi

done

echo
echo "==============================================="
echo "ALL NEGATIVE TESTS PASSED"
echo "==============================================="
