#!/usr/bin/env bash
set -e

cd ~/ultrahonk_hello/noir
cp tests/regression/negative/bad_registry/Prover.toml phase4_orchestrator/Prover.toml
cd phase4_orchestrator
nargo execute
