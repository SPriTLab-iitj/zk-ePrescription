# Regression Test Suite

This directory contains regression tests for the UltraHonk e-Prescription prototype.

## Positive

run_positive.sh

Expected:
- Witness generation succeeds.

## Negative

### run_bad_signature.sh

Mutation:
- signature_s modified

Expected:
- assert(signature_valid) fails

### run_expired.sh

Mutation:
- current_date > expiry_date

Expected:
- assert(policy_result[1]) fails

### run_threshold.sh

Mutation:
- slot_index >= quantity_threshold

Expected:
- assert(policy_result[0]) fails

Run all tests:

./tests/regression/run_all.sh
