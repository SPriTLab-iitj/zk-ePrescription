#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP="${TMPDIR:-/tmp}/zkep-circom-e2e"

rm -rf "$TMP"
mkdir -p "$TMP"

echo "== Compile =="
circom "$ROOT/circuits/08_eprescription_main.circom" \
  --r1cs --wasm --sym -o "$TMP"

echo
echo "== Valid witness =="
node "$TMP/08_eprescription_main_js/generate_witness.js" \
  "$TMP/08_eprescription_main_js/08_eprescription_main.wasm" \
  "$ROOT/inputs/eprescription/eprescription_depth4_leaf0.json" \
  "$TMP/valid.wtns"

snarkjs wtns check \
  "$TMP/08_eprescription_main.r1cs" \
  "$TMP/valid.wtns"

echo
echo "== Negative witness checks =="

for input in \
  eprescription_depth4_bad_disclosure.json \
  eprescription_depth4_bad_expiry.json \
  eprescription_depth4_bad_registry.json \
  eprescription_depth4_bad_root.json \
  eprescription_depth4_bad_threshold.json
do
    echo "Testing $input"

    if node "$TMP/08_eprescription_main_js/generate_witness.js" \
      "$TMP/08_eprescription_main_js/08_eprescription_main.wasm" \
      "$ROOT/inputs/eprescription/$input" \
      "$TMP/negative.wtns" \
      >"$TMP/error.log" 2>&1
    then
        echo "FAIL: $input was unexpectedly accepted"
        cat "$TMP/error.log"
        exit 1
    fi

    if grep -q "Assert Failed" "$TMP/error.log"; then
        echo "PASS: rejected by circuit"
    else
        echo "FAIL: unexpected tool/input error"
        cat "$TMP/error.log"
        exit 1
    fi
done

echo
echo "Circom functional tests passed."
