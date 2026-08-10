# Orchestrator Security Review

**Project:** zk-ePrescription (UltraHonk Prototype)

**Circuit:** Phase 4 – Orchestrator

**Version:** v1.0

**Status:** REVIEWED

---

# 1. Purpose

The Phase 4 Orchestrator is the final enforcement circuit of the zk-ePrescription protocol.

Unlike the lower-level circuits (Commitment, Policy, Registry, Signature, and Outputs), which independently evaluate individual cryptographic properties, the Orchestrator combines them into a single Zero-Knowledge proof.

Its responsibility is to ensure that every required security property holds simultaneously before a proof can be generated.

If any required property fails, proof generation fails due to circuit constraints.

---

# 2. Security Objectives

The Orchestrator must guarantee the following properties:

1. Prescription Integrity
2. Doctor Authentication
3. Doctor Authorization
4. Prescription Policy Compliance
5. Replay Protection
6. Zero-Knowledge Privacy
7. Cryptographic Soundness

These properties collectively define the security guarantees of the prototype.

---

# 3. Threat Model

The protocol assumes an adversary may attempt one or more of the following attacks:

- Forge a prescription.
- Modify prescription contents.
- Change the medicine after prescription issuance.
- Impersonate an authorized doctor.
- Forge a doctor's signature.
- Tamper with the Merkle authentication path.
- Replace the registry root.
- Redeem an expired prescription.
- Exceed the allowed redemption threshold.
- Replay a previously redeemed prescription.
- Modify public outputs while preserving the proof.

The Orchestrator is designed to reject such attacks by enforcing circuit constraints.

---

# 4. Architecture Overview

The Orchestrator coordinates five independent modules.

```
                Private Witness
                       │
 ┌─────────────────────┼─────────────────────┐
 │                     │                     │
Prescription       Doctor              Patient Secret
 │                     │                     │
 │                     ▼                     │
 │             Registry Proof               │
 │                     │                     │
 ▼                     ▼                     ▼
Commitment ─────────► Signature ◄────────────┘
     │                  │
     │                  ▼
     │          Signature Valid
     │
     ▼
Policy Evaluation
     │
     ▼
Assertions
     │
     ▼
Outputs
(Commitment, Nullifier)
```

The Orchestrator itself performs almost no cryptographic computation.

Instead, it orchestrates reusable cryptographic components and enforces that every validation succeeds.

---

# 5. Module Responsibilities

## 5.1 Commitment Module

### Purpose

Computes a cryptographic commitment over:

- Prescription ID
- Doctor ID
- Medicine Code

using the Poseidon2 hash function.

### Responsibility

Bind the prescription data into a single immutable commitment.

### Security Property

Prevents modification of prescription contents without changing the commitment.

---

## 5.2 Policy Module

### Purpose

Evaluates whether the prescription satisfies:

- Quantity Threshold
- Expiry Date

### Responsibility

Returns two boolean values:

- quantity_valid
- expiry_valid

### Security Property

Evaluates policy only.

It does **not** enforce policy.

Enforcement occurs inside the Orchestrator.

---

## 5.3 Registry Module

### Purpose

Verifies that the doctor's public key belongs to the authorized registry.

### Inputs

- Registry Root
- Doctor ID
- Doctor Public Key
- Merkle Authentication Path

### Responsibility

Reconstruct the Merkle Root from the supplied authentication path.

### Security Property

Guarantees doctor authorization.

Returns only a boolean.

Enforcement occurs inside the Orchestrator.

---

## 5.4 Schnorr Module

### Purpose

Verifies the doctor's BabyJubJub Schnorr signature.

### Checks

- Public key lies on the curve.
- Signature nonce lies on the curve.
- Signature scalar is within the subgroup.
- Signature equation is satisfied.

### Security Property

Guarantees that the authorized doctor signed the commitment.

Returns only a boolean.

Enforcement occurs inside the Orchestrator.

---

## 5.5 Outputs Module

### Purpose

Computes the replay-protection nullifier.

### Public Outputs

- Commitment
- Nullifier

### Security Property

The nullifier uniquely binds:

- Patient Secret
- Commitment
- Slot Index

Changing any of these values changes the nullifier.

This prevents replay attacks.

---

# 6. Enforcement Logic

The Orchestrator enforces four critical constraints.

```
assert(policy_result[0]);
assert(policy_result[1]);
assert(registry_valid);
assert(signature_valid);
```

A proof can only be generated if:

- Quantity policy succeeds.
- Expiry policy succeeds.
- Registry verification succeeds.
- Signature verification succeeds.

If any assertion fails, witness generation fails and no proof is produced.

---

# 7. Public Inputs

The current implementation exposes:

- Registry Root

---

# 8. Public Outputs

The verifier receives:

- Commitment
- Nullifier

No additional prescription information is revealed.

---

# 9. Private Witness

The private witness contains:

- Prescription ID
- Doctor ID
- Doctor Public Key
- Medicine Code
- Quantity Threshold
- Expiry Date
- Current Date
- Patient Secret
- Slot Index
- Merkle Path
- Schnorr Signature

These values remain hidden from the verifier.

---

# 10. Security Property Matrix

| Security Property | Module Responsible | Enforcement |
|-------------------|-------------------|-------------|
| Prescription Integrity | Commitment | Poseidon2 Commitment |
| Doctor Authentication | Schnorr | Signature Verification |
| Doctor Authorization | Registry | Merkle Proof |
| Policy Compliance | Policy | Quantity + Expiry |
| Replay Protection | Outputs | Nullifier |
| Protocol Enforcement | Main | Circuit Assertions |

---

# 11. Security Review

The following attack scenarios were considered.

## Prescription Modification

Result:

Rejected.

Changing the prescription changes the commitment, invalidating the signature.

---

## Doctor Impersonation

Result:

Rejected.

The public key must belong to the authorized registry and satisfy the signature equation.

---

## Invalid Registry Path

Result:

Rejected.

Merkle root reconstruction fails.

---

## Invalid Registry Root

Result:

Rejected.

Computed root does not equal the public registry root.

---

## Invalid Signature

Result:

Rejected.

BabyJubJub signature verification fails.

---

## Expired Prescription

Result:

Rejected.

Expiry policy evaluates to false.

---

## Threshold Exceeded

Result:

Rejected.

Quantity policy evaluates to false.

---

## Replay Attack

Result:

Rejected.

The same prescription generates the same nullifier.

Previously redeemed nullifiers can be rejected by the verifier or backend.

---

# 12. Assumptions

The protocol assumes:

- Poseidon2 is collision resistant.
- BabyJubJub discrete logarithm remains computationally hard.
- The registry root is trusted.
- Doctor public keys are correctly registered.
- Patient secrets remain private.
- Registry updates occur outside the circuit.

---

# 13. Current Limitations

Version 1 intentionally includes the following limitations.

- Registry depth is instantiated as 2 within the Orchestrator.
- No recursive proof composition.
- No revocation tree.
- No policy Merkle tree.
- Static policy evaluation.
- No blockchain verifier integration.
- Single-signature workflow.

These limitations are acceptable for the current research prototype.

---

# 14. Future Improvements

Potential enhancements include:

- Generic registry depth.
- Dynamic registry updates.
- Revocation tree support.
- Policy Merkle tree.
- Recursive proof composition.
- Batch verification.
- Mobile proof generation optimizations.
- Multi-signature prescriptions.
- On-chain verifier integration.

---

# 15. Final Assessment

The Phase 4 Orchestrator successfully composes the Commitment, Policy, Registry, Schnorr Signature, and Output modules into a single enforcement circuit.

The circuit guarantees that a proof can only be generated when:

- the prescription commitment is correctly formed,
- the doctor belongs to the authorized registry,
- the doctor's signature is valid,
- the prescription satisfies the defined policy,
- and the commitment and nullifier are consistently derived.

Any violation of these properties results in a circuit constraint failure, preventing proof generation.

The modular architecture enables independent testing of each component while maintaining a single enforcement point within the Orchestrator.

This completes the Version 1 security review of the UltraHonk zk-ePrescription Orchestrator.
