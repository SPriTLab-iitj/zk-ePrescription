#!/usr/bin/env bash
set -euo pipefail

cd ~/ultrahonk_hello/noir
cp tests/regression/positive/Prover.toml phase4_orchestrator/Prover.toml
cd phase4_orchestrator
nargo execute
