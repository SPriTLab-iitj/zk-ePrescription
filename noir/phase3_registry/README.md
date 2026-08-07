# Phase 3 Registry Circuit

## Purpose
The `phase3_registry` circuit verifies that a specific doctor is authorized and present within a depth-2 Merkle tree registry.

## Architecture
This circuit uses `common::poseidon2_hash::registry_leaf_hash` to bind the doctor's ID and public key into a single leaf node. It then iterates over the provided depth-2 Merkle authentication path using `merkle_node_hash`. Finally, it strictly asserts that the computed Merkle root matches the known public `registry_root`.

### Public Inputs (Outputs)
- **Input Argument**: `registry_root` (`pub Field`)
- **Return Value**: `true` (`pub bool`)

### Private Inputs
- `doctor_id` (`Field`)
- `doctor_pubkey_x` (`Field`)
- `doctor_pubkey_y` (`Field`)
- `sibling0` (`Field`)
- `sibling1` (`Field`)
- `direction0` (`bool`)
- `direction1` (`bool`)

## Dependencies
- `common::poseidon2_hash`

## Registry Verification & Proof Generation Flow
1. Prover collects the `doctor_id` and their public key (`doctor_pubkey_x`, `doctor_pubkey_y`).
2. Prover retrieves the Merkle proof (`sibling0`, `sibling1`, `direction0`, `direction1`) and the authoritative `registry_root`.
3. Prover feeds these into the circuit, generating a witness (`nargo execute`) and generating a SNARK proof (`bb prove`).
4. Verifier calls `bb verify` matching the proof against the `registry_root`.

## Regression Suite
An extensive set of test vectors exists under `tests/`:
- **Positive Tests**: 5 vectors representing valid doctors and varying paths.
- **Negative Tests**: 6 security vectors guarding against unauthorized access, tampered leaves, and spoofed tree topology.

## Validation Summary
The circuit has been formally reviewed, aggressively tested with UltraHonk, and all security assertions behave flawlessly. The circuit is mathematically sound and is officially marked as **FROZEN**.
