# Circom Implementation

This directory contains the Circom implementation of the
**zk-ePrescription** research prototype.

The implementation provides an alternative realization of the
privacy-preserving prescription verification protocol using **Circom** and
**Groth16**. It includes modular cryptographic circuits, a Poseidon-based
Merkle doctor registry, BabyJubJub/Schnorr signature verification, and an
integrated e-Prescription circuit.

This implementation is intended for **research and comparative evaluation**,
not production deployment.

---

## Overview

The Circom implementation integrates the following prescription verification
properties:

- Prescription commitment
- Patient identity binding
- Nullifier generation for replay protection
- Redemption threshold enforcement
- Authorized doctor registry membership
- Prescription expiry validation
- Selective medicine disclosure
- BabyJubJub/Schnorr signature verification
- Integrated prescription verification
- Groth16 proof generation and verification

The protocol is implemented as reusable circuit modules and combined in the
main e-Prescription circuit.

---

## Circuit Architecture

```text
01_commitment.circom
        │
        ▼
02_identity_binding.circom
        │
        ▼
03_nullifier.circom
        │
        ▼
04_threshold.circom
        │
        ▼
05_doctor_registry_merkle_lib.circom
05_merkle_parameterized.circom
        │
        ▼
06_schnorr_bjj.circom
        │
        ▼
07_selective_disclosure.circom
        │
        ▼
08_eprescription_main.circom
        │
        ▼
     Groth16
```

---

## Circuit Components

| Circuit | Purpose |
|---|---|
| `01_commitment.circom` | Generates the prescription commitment |
| `02_identity_binding.circom` | Binds the prescription proof to the relevant identity information |
| `03_nullifier.circom` | Generates a deterministic nullifier for replay protection |
| `04_threshold.circom` | Enforces the configured prescription redemption threshold |
| `05_doctor_registry_merkle_lib.circom` | Provides parameterized Merkle membership verification logic |
| `05_merkle_parameterized.circom` | Implements the parameterized Poseidon Merkle registry |
| `06_schnorr_bjj.circom` | Verifies the BabyJubJub/Schnorr signature |
| `07_selective_disclosure.circom` | Enforces selective disclosure of medicine information |
| `08_eprescription_main.circom` | Integrates the complete prescription verification flow |
| `lib_modules.circom` | Shared circuit imports and module definitions |

---

## Doctor Registry

Doctor authorization is implemented using a **Poseidon-based Merkle tree**.

The circuit verifies a doctor's registry membership using:

- the doctor's Merkle leaf,
- Merkle path elements,
- path direction bits, and
- the expected Merkle root.

The circuit recomputes the path from the doctor leaf to the root and verifies
that the resulting root matches the authorized registry root.

### Parameterized Depth

The Merkle registry is parameterized by tree depth.

```text
Depth 2 → 4 leaves
Depth 4 → 16 leaves
Depth 8 → 256 leaves
```
