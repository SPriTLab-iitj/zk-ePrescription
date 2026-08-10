#!/usr/bin/env bash
set -u

cd ~/ultrahonk_hello/noir
cp tests/regression/negative/expired/Prover.toml phase4_orchestrator/Prover.toml
cd phase4_orchestrator

if nargo execute >/tmp/expired.out 2>&1; then
    echo "EXPIRED: unexpected PASS"
    cat /tmp/expired.out
    exit 1
else
    echo "EXPIRED: PASS (failed as expected)"
    cat /tmp/expired.out
fi
