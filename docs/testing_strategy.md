
---

# `docs/testing_strategy.md`

```md
# Testing Strategy

## Principles

- Every module gets unit tests.
- Every phase gets positive and negative tests.
- Tests should validate logic before integration.
- Proof generation is the final acceptance check.

## Hash module tests

The shared hash layer must test:

- determinism
- domain separation
- leaf sensitivity
- Merkle node order sensitivity
- leaf vs node non-collision

## Registry generator tests

The registry generator must test:

- tree construction
- root stability
- authentication path extraction
- correct direction encoding
- correct sibling selection for doctor indices 0–3

## Phase 1 tests

Test:

- valid commitment and nullifier generation
- deterministic outputs
- nullifier changes with slot index
- commitment remains consistent for the same input

## Phase 2 tests

Test:

- valid threshold inputs
- valid expiry inputs
- failing threshold inputs
- failing expiry inputs

## Phase 3 tests

Test:

- valid registry membership
- invalid sibling values
- wrong root
- wrong direction bits
- wrong doctor index

## Phase 4 tests

Test:

- valid Schnorr signature passes
- invalid signature fails
- wrong public key fails
- wrong commitment fails

## Phase 5 tests

Test:

- public outputs remain minimal
- private values stay private
- no unintended ABI expansion

## Negative test policy

Use explicit failing cases for each phase. If a check should fail, it must be tested as a failure case before the phase is considered complete.

## Acceptance rule

A phase is only complete when:
- unit tests pass,
- compile passes,
- witness generation passes,
- proof generation passes,
- proof verification passes.
