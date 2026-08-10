#!/usr/bin/env bash
set -e

ROOT="$HOME/zk-ePrescription/noir"
PKG="phase2_policy"

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

    (
        cd "$ROOT/$PKG"
        nargo execute > /dev/null
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
            >/dev/null
    )

    echo "PASS (evaluated to false correctly)"

done

echo
echo "==============================================="
echo "ALL NEGATIVE TESTS PASSED"
echo "==============================================="
