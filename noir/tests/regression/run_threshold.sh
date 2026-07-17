#!/usr/bin/env bash
set -u

cd ~/ultrahonk_hello/noir
cp tests/regression/negative/threshold/Prover.toml phase4_orchestrator/Prover.toml
cd phase4_orchestrator

if nargo execute >/tmp/threshold.out 2>&1; then
    echo "THRESHOLD: unexpected PASS"
    cat /tmp/threshold.out
    exit 1
else
    echo "THRESHOLD: PASS (failed as expected)"
    cat /tmp/threshold.out
fi
