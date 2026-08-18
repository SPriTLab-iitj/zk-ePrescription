# zk-ePrescription

**Privacy-Preserving Electronic Prescription Verification using Zero-Knowledge Proofs**

A research prototype exploring privacy-preserving electronic prescription
verification without requiring disclosure of the complete prescription during
redemption.

## Overview

The protocol enables a verifier to establish that a prescription satisfies
the required verification conditions while minimizing disclosure of sensitive
prescription information.

The prototype covers:

- prescription commitment,
- patient identity binding,
- replay protection through nullifiers,
- redemption threshold enforcement,
- prescription expiry,
- authorized doctor registry membership,
- selective disclosure, and
- BabyJubJub/Schnorr signature verification.

## Implementations

The repository contains two independent implementations.

### Noir

**Noir + UltraHonk + Barretenberg + Poseidon2**

Located in `noir/`.

### Circom

**Circom + Groth16 + Poseidon + BabyJubJub**

Located in `circom/`.

The two implementations are intentionally tested independently.

## Repository Structure

```text
zk-ePrescription/
├── noir/
│   ├── common/
│   ├── docs/
│   ├── phase1_commitment_nullifier/
│   ├── phase2_policy/
│   ├── phase3_registry/
│   └── phase4_orchestrator/
│
├── circom/
│   ├── circuits/
│   ├── inputs/
│   ├── scripts/
│   ├── docs/
│   └── benchmarks/
│
└── paper/
