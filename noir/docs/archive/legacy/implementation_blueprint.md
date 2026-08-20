
---

# `docs/implementation_blueprint.md`

```md
# Implementation Blueprint

## Goal

Build a privacy-preserving e-Prescription redemption system using Noir + UltraHonk that demonstrates:

- prescription commitment binding
- internal identity binding
- nullifier-based replay protection
- doctor authorization through a Merkle registry
- Schnorr signature verification
- selective disclosure
- UltraHonk proof generation and verification

## Guiding principles

1. Stability over bleeding-edge features.
2. Simplicity over unnecessary abstraction.
3. Deterministic architecture.
4. Modular implementation.
5. Minimal code duplication.
6. Reproducibility.
7. Research-quality engineering.
8. Compatibility with the frozen toolchain.
9. One responsibility per module.
10. Frozen architecture decisions.

## Frozen decisions

### Package layout
- One executable = one package.
- No nested `Nargo.toml` files.
- Shared code exists once only.

### Shared code
- `common/poseidon2_hash.nr` is the single source of truth for hash wrappers.

### Data structures
- Avoid structs unless absolutely necessary.
- Prefer fixed arrays for cross-package APIs.

### Registry design
- Leaf:
  `Poseidon2(DOMAIN_REGISTRY_LEAF, doctor_id, pubkey_x, pubkey_y)`
- Internal node:
  `Poseidon2(DOMAIN_MERKLE_NODE, left_child, right_child)`
- Tree depth: `2`
- Authentication path layout:
  `[leaf, sibling0, sibling1, direction0, direction1, root]`

### Generator / verifier split
- `registry_generator` builds the tree and authentication path.
- `phase3_registry` verifies membership using generated values.
- The verifier never builds the tree.
- The generator never verifies proofs.

## Phase roadmap

### Phase 1
Commitment + nullifier.

### Phase 2
Policy checks:
- quantity / threshold
- expiry

### Phase 3
Doctor registry:
- Merkle tree construction
- authentication path generation
- membership verification

### Phase 4
Schnorr signature verification.

### Phase 5
Selective disclosure hardening.

### Phase 6
Integrated UltraHonk circuit.

## Exit rule for each phase

A phase is complete only when:
- `nargo check` passes,
- `nargo execute` passes,
- `bb prove` passes,
- `bb verify` passes.

## Change-control rule

Once the blueprint is frozen, implementation must follow it. Do not redesign module interfaces during coding unless the toolchain forces a correction.
