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
- Nullifier generation for replay protection
- Redemption threshold enforcement
- Authorized doctor registry membership
- Prescription expiry validation
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
        │
        ▼
06_schnorr_bjj.circom
        │
        ▼
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
| `06_schnorr_bjj.circom` | Verifies the BabyJubJub/Schnorr signature |
| `08_eprescription_main.circom` | Integrates the complete prescription redemption verification flow |
| `09_patient_prescription_binding_issuance.circom` | Computes the issuance-side patient–prescription binding |
| `lib_modules.circom` | Shared circuit imports and module definitions |

---

## Patient Identity Binding

The repository also includes a separate issuance-side patient-binding circuit.

Registration establishes a patient binding from the authenticated external
health-identity process. During prescription issuance, that binding is
associated with the existing prescription commitment.

The pharmacy redemption circuit does not require fresh authentication against
the external health-identity system.

## Doctor Registry

Doctor authorization is implemented using a **Poseidon-based Merkle tree**.

The circuit verifies a doctor's registry membership using:

- the doctor's Merkle leaf,
- Merkle path elements,
- path direction bits, and
- the expected Merkle root.

The circuit recomputes the path from the doctor leaf to the root and verifies
that the resulting root matches the authorized registry root.

### Merkle Depth

The underlying Merkle verification component is parameterized by tree depth.

The current integrated e-Prescription circuit instantiates the registry at
depth 4 (16 leaves).

```text
Merkle component:
Depth 2 → 4 leaves
Depth 4 → 16 leaves
Depth 8 → 256 leaves

Current integrated circuit:
Depth 4 → 16-leaf registry
```
