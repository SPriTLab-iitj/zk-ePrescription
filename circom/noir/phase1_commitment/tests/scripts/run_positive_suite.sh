#!/usr/bin/env bash
set -e

ROOT="$HOME/zk-ePrescription/noir"
PKG="phase1_commitment"

echo
echo "==============================================="
echo "Running Positive Suite"
echo "Package : $PKG"
echo "==============================================="

# Compile once
(
    cd "$ROOT"
    nargo compile --package "$PKG"
)

for VECTOR in "$ROOT/$PKG/tests/positive"/*.toml
do
    NAME=$(basename "$VECTOR")

    echo
    echo ">>> $NAME"

    cp "$VECTOR" "$ROOT/$PKG/Prover.toml"

    (
        cd "$ROOT/$PKG"
        nargo execute
    )

    (
        cd "$ROOT"

        bb prove \
            -b target/${PKG}.json \
            -w target/${PKG}.gz \
            --write_vk \
            -o target \
            >/dev/null

        bb verify \
            -k target/vk \
            -p target/proof \
            -i target/public_inputs \
            >/dev/null
    )

    echo "PASS"

done

echo
echo "==============================================="
echo "ALL POSITIVE TESTS PASSED"
echo "==============================================="
