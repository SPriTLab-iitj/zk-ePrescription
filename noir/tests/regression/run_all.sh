#!/usr/bin/env bash
set -e

./tests/regression/run_positive.sh
./tests/regression/run_bad_signature.sh
./tests/regression/run_expired.sh
./tests/regression/run_threshold.sh

echo "ALL REGRESSION TESTS PASSED"
