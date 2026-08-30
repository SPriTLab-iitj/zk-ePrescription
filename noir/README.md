# Noir Implementation

This directory contains the Noir implementation of the **zk-ePrescription** research prototype.

The Noir and Circom implementations are maintained independently. They use different circuit languages and proving systems and are tested separately.

## Implementation Stack

- Circuit language: Noir
- Proving system: UltraHonk
- Proving backend: Barretenberg
- Hash function: Poseidon2
- Signature curve: BabyJubJub
- Registry: Poseidon2-based Merkle tree

## Components

### `common/`
Shared cryptographic primitives used by the Noir implementation.

### `components/commitment_nullifier/`

Standalone research components for prescription commitment and replay-protection
nullifier computation.


### `phase2_policy/`
Prescription expiry and redemption-threshold enforcement.

### `phase3_registry/`
Authorized doctor membership using a Poseidon2-based Merkle registry.

### `patient_binding_issuance/`

Issuance-side patient identity binding and patient–prescription association.

The package derives a patient binding from the private patient secret and
associates it with the existing prescription commitment without modifying the
existing commitment construction.

### `phase4_orchestrator/`
Integrated commitment, policy, registry, signature verification, and output generation.

## Validation

Run the integrated Phase 4 regression suites:

```bash
cd phase4_orchestrator/tests/scripts
./run_positive_suite.sh
./run_negative_suite.sh
```

The positive suite generates and verifies an UltraHonk proof.

The negative suite verifies rejection of invalid signatures, invalid doctor registry membership, expired prescriptions, redemption threshold violations, and prescription tampering.

## Research Prototype

This implementation is intended for research and comparative evaluation. It is not a production healthcare deployment.
