#!/usr/bin/env bash
set -u

cd ~/ultrahonk_hello/noir
cp tests/regression/negative/bad_signature/Prover.toml phase4_orchestrator/Prover.toml
cd phase4_orchestrator

if nargo execute >/tmp/bad_signature.out 2>&1; then
    echo "BAD SIGNATURE: unexpected PASS"
    cat /tmp/bad_signature.out
    exit 1
else
    echo "BAD SIGNATURE: PASS (failed as expected)"
    cat /tmp/bad_signature.out
fi
