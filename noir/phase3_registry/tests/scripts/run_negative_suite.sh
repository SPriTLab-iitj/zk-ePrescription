#!/usr/bin/env bash

ROOT="$HOME/zk-ePrescription/noir"
PKG="phase3_registry"

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

FAILS=0
TOTAL=0

for VECTOR in "$ROOT/$PKG/tests/negative"/*.toml
do
    TOTAL=$((TOTAL+1))
    NAME=$(basename "$VECTOR")

    echo
    echo ">>> $NAME"

    cp "$VECTOR" "$ROOT/$PKG/Prover.toml"

    pushd "$ROOT/$PKG" > /dev/null
    if nargo execute > /dev/null 2>&1; then
        echo "FAIL: Expected $NAME to fail, but it succeeded!"
        popd > /dev/null
        exit 1
    else
        echo "PASS (correctly rejected)"
        FAILS=$((FAILS+1))
    fi
    popd > /dev/null
done

if [ "$FAILS" -eq "$TOTAL" ]; then
    echo
    echo "==============================================="
    echo "ALL $TOTAL NEGATIVE TESTS PASSED"
    echo "==============================================="
else
    echo "Only $FAILS/$TOTAL negative tests passed."
    exit 1
fi
