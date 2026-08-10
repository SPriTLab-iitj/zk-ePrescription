# Phase 1 Commitment Library

## Purpose
The `phase1_commitment` package validates the commitment creation. It proves that a prover knows a set of private data (a prescription, a doctor, a medicine, a patient's secret, and a specific index) that deterministically generates a specific cryptographic commitment (binding the prescription details) and a specific nullifier (for replay protection), utilizing the `Poseidon2` hash function.

## Architecture & API
### Public Inputs (Outputs)
- `commitment` (`Field`): The hash of the prescription details.
- `nullifier` (`Field`): The hash combining the patient secret, the commitment itself, and the slot index.

### Private Inputs
- `prescription_id` (`Field`)
- `doctor_id` (`Field`)
- `medicine_code` (`Field`)
- `patient_secret` (`Field`)
- `slot_index` (`u32`)

## Validation Summary
The circuit has been extensively tested using dedicated positive and negative vectors.
- **Positive Tests**: 3 vectors verifying standard behavior, deterministic recomputation, and salt variations.
- **Negative Tests**: 4 vectors verifying rejection of tampered nullifiers, wrong secrets, wrong salts, and modified inputs/commitments.

## Frozen Status
All initial design reviews, testing suites, and cryptographic boundaries for this circuit have been finalized and marked as **FROZEN**.

---

### Checklist Completion
- [x] Design Review
- [x] Compile
- [x] Execute
- [x] UltraHonk Proof
- [x] Verify
- [x] Positive Tests
- [x] Negative Tests
- [x] Documentation
- [x] Freeze
