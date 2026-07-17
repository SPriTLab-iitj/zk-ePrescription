# Phase 3 Testing Strategy
## Registry Membership Verification

---

# Purpose

This document defines the testing methodology for the Phase 3
Doctor Registry Membership subsystem.

The objective is to verify that:

- Every legitimate doctor can prove membership.
- Any modification of the doctor record fails verification.
- Any modification of the authentication path fails verification.
- Any modification of the Merkle directions fails verification.
- Any modification of the public registry root fails verification.

These tests validate the correctness of the Merkle membership circuit.

---

# Components Under Test

Generator

```
registry_generator
```

Responsibilities

- Build registry leaves
- Build Merkle tree
- Generate authentication path
- Export verifier inputs

---

Verifier

```
phase3_registry
```

Responsibilities

- Recompute registry leaf
- Verify authentication path
- Recompute registry root
- Compare against public registry root

---

# Test Procedure

For every test:

Step 1

Execute

```
registry_generator
```

to obtain

- registry_root
- doctor_id
- doctor_pubkey_x
- doctor_pubkey_y
- sibling0
- sibling1
- direction0
- direction1

---

Step 2

Copy the generated values into

```
phase3_registry/Prover.toml
```

---

Step 3

Execute

```
nargo execute
```

inside

```
phase3_registry
```

---

Step 4

Generate an UltraHonk proof

```
bb write_vk

bb prove

bb verify
```

---

Expected Result

Positive tests

```
Proof verified successfully
```

Negative tests

```
Constraint failure
```

or

```
Assertion failed
```

depending on the modified value.

---

# Positive Test Cases

---

## Test P1

Doctor Index

```
0
```

Purpose

Verify membership for Doctor 1.

Expected

PASS

---

## Test P2

Doctor Index

```
1
```

Purpose

Verify membership for Doctor 2.

Expected

PASS

---

## Test P3

Doctor Index

```
2
```

Purpose

Verify membership for Doctor 3.

Expected

PASS

---

## Test P4

Doctor Index

```
3
```

Purpose

Verify membership for Doctor 4.

Expected

PASS

---

# Negative Test Cases

---

## Test N1

Modification

```
doctor_id
```

Example

```
5001

↓

9999
```

Purpose

Detect forged doctor identity.

Expected

FAIL

---

## Test N2

Modification

```
doctor_pubkey_x
```

Purpose

Detect modified public key.

Expected

FAIL

---

## Test N3

Modification

```
sibling0
```

Purpose

Detect corrupted authentication path.

Expected

FAIL

---

## Test N4

Modification

```
sibling1
```

Purpose

Detect corrupted authentication path.

Expected

FAIL

---

## Test N5

Modification

```
direction0
```

Purpose

Detect incorrect left/right ordering.

Expected

FAIL

---

## Test N6

Modification

```
direction1
```

Purpose

Detect incorrect left/right ordering.

Expected

FAIL

---

## Test N7

Modification

```
registry_root
```

Purpose

Detect proof against an incorrect registry.

Expected

FAIL

---

# Security Properties Verified

The above tests demonstrate:

✓ Correct registry membership verification

✓ Correct authentication path verification

✓ Correct left/right Merkle hashing

✓ Binding of doctor identity to registry membership

✓ Binding of registry proof to a specific registry root

✓ Detection of tampered authentication paths

✓ Detection of forged doctor identities

✓ Detection of incorrect registry commitments

---

# Completion Criteria

Phase 3 is considered complete when:

- All four positive tests pass.
- All seven negative tests fail.
- UltraHonk proof generation succeeds.
- UltraHonk proof verification succeeds.
- Benchmark results are recorded.
