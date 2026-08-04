#!/usr/bin/env bash
set -e

ROOT="$HOME/ultrahonk_v1/noir"

run_depth() {

    DEPTH=$1
    PKG="merkle_verify_d${DEPTH}"

    echo
    echo "==============================================="
    echo "Running Depth-$DEPTH Positive Suite"
    echo "Package : $PKG"
    echo "==============================================="

    #
    # Compile once
    #
    (
        cd "$ROOT"
        nargo compile --package "$PKG"
    )

    #
    # Execute every vector
    #
    for VECTOR in "$ROOT/merkle/tests/vectors/depth${DEPTH}"/*.toml
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
}

run_depth 2
run_depth 3
run_depth 4

echo
echo "==============================================="
echo "ALL POSITIVE TESTS PASSED"
echo "==============================================="
