#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo
echo "=================================================="
echo " zk-ePrescription Full Regression Test"
echo "=================================================="

echo
echo "==================== CIRCOM ======================"

(
    cd "$ROOT/circom"
    npm test
)

echo
echo "===================== NOIR ======================="

(
    cd "$ROOT/noir/phase4_orchestrator/tests/scripts"
    ./run_positive_suite.sh
    ./run_negative_suite.sh
)

echo
echo "============== PATIENT BINDING ==================="

(
    cd "$ROOT/noir/patient_binding_issuance"
    nargo check
    nargo test
)

echo
echo "==================== SHARED PROTOCOL Known Answer Tests (KATs) ======================"

(
    cd "$ROOT"
    python3 scripts/test_shared_kats.py
)

echo
echo "=================================================="
echo " ALL REGRESSION TESTS PASSED"
echo "=================================================="
