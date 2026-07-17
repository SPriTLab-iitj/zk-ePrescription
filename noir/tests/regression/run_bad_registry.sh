#!/usr/bin/env bash
set -u

cd ~/ultrahonk_hello/noir
cp tests/regression/negative/bad_registry/Prover.toml phase4_orchestrator/Prover.toml
cd phase4_orchestrator

if nargo execute >/tmp/bad_registry.out 2>&1; then
    echo "BAD REGISTRY: unexpected PASS"
    cat /tmp/bad_registry.out
    exit 1
else
    echo "BAD REGISTRY: PASS (failed as expected)"
    cat /tmp/bad_registry.out
fi
