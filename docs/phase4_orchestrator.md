# Phase 4: Orchestrator

## Purpose

The Phase 4 Orchestrator is the integrated enforcement circuit of the Noir
zk-ePrescription implementation.

It combines the major protocol components and enforces that all required
conditions hold before a proof can be generated.

## Modules

The orchestrator imports:

- `commitment`
- `policy`
- `registry`
- `schnorr`
- `outputs`
- `bjj_core`

## Processing Flow

The current `main` function performs the following steps.

### 1. Commitment

The circuit computes a prescription commitment from:

- `prescription_id`
- `doctor_id`
- `medicine_code`

### 2. Policy

The circuit evaluates:

- quantity threshold
- expiry date
- current date
- slot index

### 3. Registry

Doctor membership is verified against the public registry root using a
parameterized Merkle path.

The current orchestrator instantiates the verifier at depth 4.

### 4. Schnorr

The circuit verifies the doctor's BabyJubJub/Schnorr signature over the
computed commitment.

### 5. Outputs

The circuit derives the final public outputs from the commitment and
replay-protection inputs.

The returned public output is:

```text
[commitment, nullifier]
