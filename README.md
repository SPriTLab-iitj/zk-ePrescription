# zk-ePrescription

**Privacy-Preserving Electronic Prescription Verification using Zero-Knowledge Proofs**

A research prototype exploring privacy-preserving electronic prescription
verification without requiring disclosure of the complete prescription during
redemption.

## Overview

The protocol enables a verifier to establish that a prescription satisfies
the required verification conditions while minimizing disclosure of sensitive
prescription information.

## Goals and Objectives

The zk-ePrescription prototype is designed to provide:

- **Prescription Integrity** — protect prescription data from unauthorized modification.
- **Prescription Authenticity** — verify that the prescription commitment was signed by an authorized doctor.
- **Authorized Doctor Verification** — verify that the signing doctor is part of the trusted doctor registry.
- **Patient–Prescription Binding** — associate a prescription with the registered patient's health identity during issuance.
- **Patient Privacy** — minimize unnecessary exposure of sensitive patient and prescription information.
- **Selective Disclosure** — reveal only the prescription attributes required for verification.
- **Zero-Knowledge Verification** — prove required prescription properties without revealing the complete private witness.
- **Policy Enforcement** — enforce expiry and redemption limits.
- **Replay Protection** — prevent reuse of an already redeemed redemption slot.
- **Bearer-Friendly Redemption** — allow the patient or an authorized bearer such as a relative to redeem the prescription.
- **Redemption Accountability** — record redemption events and support patient-side tracking and notification.
- **Minimal Pharmacy Dependency** — avoid repeated authentication against the national/medical health-identity system during dispensing.
- **Cross-System Evaluation** — provide implementations in Circom/Groth16 and Noir/UltraHonk for comparative research.
- **Reproducibility** — provide deterministic test vectors, positive/negative tests, and reproducible proof verification.

### Core Research Objectives

At a higher level, the project focuses on:

> **Integrity + Authenticity + Patient Binding + Privacy**

> **Selective Disclosure + Policy Enforcement + Replay Resistance**

> **Accountability + Practical Pharmacy Workflow + Reproducibility**


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
│
├── README.md                         ← FIRST THING A NEW USER READS
├── LICENSE
├── .gitignore
│
├── circom/                           ← Circom + Groth16 implementation
│   ├── README.md
│   ├── circuits/
│   │   ├── 01_commitment.circom
│   │   ├── 02_identity_binding.circom
│   │   ├── 03_nullifier.circom
│   │   ├── 04_threshold.circom
│   │   ├── 05_doctor_registry_merkle_lib.circom
│   │   ├── 05_merkle_parameterized.circom
│   │   ├── 06_schnorr_bjj.circom
│   │   ├── 07_selective_disclosure.circom
│   │   ├── 08_eprescription_main.circom
│   │   ├── 09_patient_binding_issuance.circom
│   │   └── lib_modules.circom
│   │
│   ├── inputs/
│   │   ├── eprescription/
│   │   └── merkle/
│   │
│   ├── scripts/
│   ├── docs/
│   ├── benchmarks/
│   ├── package.json
│   └── package-lock.json
│
├── noir/                             ← Noir + UltraHonk implementation
│   ├── README.md
│   ├── docs/
│   │   ├── patient_identity_binding.md
│   │   └── ...
│   ├── common/
│   ├── patient_binding_issuance/
│   ├── phase2_policy/
│   ├── phase3_registry/
│   └── phase4_orchestrator/
│
├── paper/                            ← Research paper/material
│   └── paper.md
│
├── testdata/                         ← Shared/reference data
│
├── scripts/                          ← Repository-level scripts
│
└── docker/                           ← We add later
    └── ...
