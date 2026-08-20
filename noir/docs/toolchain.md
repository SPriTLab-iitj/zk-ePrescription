# Noir Toolchain

This document records the toolchain used by the current Noir implementation of zk-ePrescription.

## Versions

- Noir / Nargo: `1.0.0-beta.24`
- noirc: `1.0.0-beta.24`
- Barretenberg / bb: `5.0.0-nightly.20260522`

## Circuit and Proving Stack

- Circuit language: Noir
- Proving system: UltraHonk
- Proving backend: Barretenberg
- Intermediate representation: ACIR

## Validation Workflow

The current Phase 4 regression suites use:

```text
nargo compile
nargo execute
bb prove
bb verify
