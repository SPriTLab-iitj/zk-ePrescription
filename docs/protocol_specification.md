# zk-ePrescription Protocol Specification

## 1. Purpose

This document is the normative protocol-level specification for the
zk-ePrescription research artifact.

The protocol is implemented independently in:

- Circom + Groth16
- Noir + UltraHonk + Barretenberg

The implementations may differ internally in circuit decomposition,
constraint representation, proving-system mechanics, and witness handling.
Where the protocol defines an equality relation, however, both implementations
must compute the same canonical field element.

This specification is the source of truth for implementation, cross-backend
known-answer tests, registry fixtures, and the research paper.

## 2. Trust and Authentication Boundary

National, regional, or institutional health-identity authentication is
external to the zero-knowledge protocol.

Raw national or health identifiers must not be placed inside the ZK circuit.

External enrollment establishes a protocol-specific patient secret or
credential. The ZK protocol consumes only the cryptographic material required
by its defined relations.

Patient-prescription binding is an issuance-side relation. It establishes a
cryptographic association between the enrolled patient context and a
prescription. It is not itself a replacement for fresh authentication against
an external health-identity system during pharmacy redemption.

## 3. Canonical Poseidon2 Construction

### 3.1 Field

Canonical protocol hashing uses the BN254 scalar field.

### 3.2 Permutation

The canonical Poseidon2 state width is:

    t = 4

The rate is:

    rate = 3

The capacity is one field element.

The tested parameterization is:

    S-box exponent = 5
    full rounds = 8 + 8
    partial rounds = 56

The Circom implementation uses the TACEO Poseidon2 t=4 construction.
The Noir implementation uses the pinned:

    std::hash::poseidon2_permutation

with Nargo/Noir beta.24.

A raw t=4 permutation known-answer test has been cross-checked between the
two implementations.

### 3.3 Canonical Project Sponge

For an input vector:

    x = [x_0, ..., x_(N-1)]

initialize:

    state = [0, 0, 0, N * 2^64]

The rate is three field elements.

For every complete three-element block:

    state[0] += x_i
    state[1] += x_(i+1)
    state[2] += x_(i+2)

then apply the Poseidon2 permutation.

After all complete blocks, absorb the remaining one or two elements, if any,
into the corresponding rate positions.

Apply one final Poseidon2 permutation.

The hash output is:

    H_N(x) = state[0]

The protocol uses fixed input lengths for each application relation.

The canonical six-element sponge path has been cross-checked between Circom
and pinned Noir beta.24.

## 4. Domain Separation

The protocol defines the following application domains:

    DOMAIN_COMMITMENT      = 1
    DOMAIN_IDENTITY        = 2
    DOMAIN_NULLIFIER       = 3
    DOMAIN_REGISTRY_LEAF   = 4
    DOMAIN_MERKLE_NODE     = 5
    DOMAIN_PATIENT_BINDING = 6

For domain D and input vector x:

    H_D(x) = H([D] || x)

where H is the canonical project sponge.

Domain values and input ordering are part of the protocol definition.

## 5. Prescription Commitment

The prescription commitment is:

    C = H_1(
        prescription_id,
        doctor_id,
        medicine_code,
        expiry,
        threshold
    )

Equivalently, the sponge input is:

    [1,
     prescription_id,
     doctor_id,
     medicine_code,
     expiry,
     threshold]

The commitment therefore binds the prescription identifier, authorized
doctor identifier, medicine code, expiry condition, and redemption threshold.

## 6. Patient Identity Binding

The protocol-specific patient identity reference is:

    I = H_2(patient_secret)

The issuance-side patient-prescription binding is:

    PB = H_6(I, C)

The external health-identity authentication process remains outside the ZK
circuit.

## 7. Nullifier and Replay Protection

The deterministic nullifier is:

    N = H_3(
        patient_secret,
        C,
        slot_index
    )

The nullifier is used as the protocol's replay-protection identifier for the
defined redemption context.

## 8. Doctor Registry

### 8.1 Registry Leaf

Each doctor registry leaf is:

    L = H_4(
        doctor_id,
        pubkey_x,
        pubkey_y
    )

### 8.2 Merkle Node

Each internal node is:

    M = H_5(left, right)

The ordering of left and right is significant.

### 8.3 Membership

A membership proof supplies the doctor registry authentication path and the
expected registry root. The verifier recomputes the leaf and all ordered
internal nodes and requires the resulting root to equal the authorized
registry root.

The aligned protocol uses the canonical Poseidon2/domain-separated construction
for both registry leaves and internal nodes.

Changing the Circom registry from its previous circomlib Poseidon construction
therefore changes registry leaves, internal nodes, roots, and authentication
paths. Registry fixtures must be regenerated after migration.

## 9. Prescription Policy

The integrated verification relation enforces, as applicable:

- prescription expiry;
- redemption threshold;
- authorized doctor registry membership;
- prescription commitment consistency;
- nullifier/replay protection;
- doctor signature validity; and
- required selective disclosure.

The logical relations are protocol-level requirements and must remain consistent
between both backends.

## 10. Doctor Signature

Doctor authorization includes the defined BabyJubJub/Schnorr signature
verification relation.

The signature relation is independent of the Merkle hashing construction.

## 11. Public and Private Data

The exact public/private interface is defined by each proof entry point, but
private witness material may include:

- patient secret;
- prescription fields not disclosed to the verifier;
- Merkle authentication path;
- doctor signature witness material; and
- other data required by the ZK relation.

Public values are those explicitly exposed by the protocol proof interface,
including the relevant commitment, registry root, nullifier, and disclosed
outputs where applicable.

## 12. Cross-Backend Equivalence

Cross-backend equality must be demonstrated using known-answer tests.

Required equalities include:

1. Poseidon2 t=4 permutation
2. canonical project sponge
3. prescription commitment
4. identity hash
5. nullifier hash
6. registry leaf hash
7. Merkle node hash
8. full registry root
9. patient-prescription binding

Circom/Groth16 and Noir/UltraHonk do not need identical proving-system
internals, proof encodings, constraint systems, or witness formats.

## 13. Required Known-Answer Tests

The artifact must provide KATs for:

- raw Poseidon2 permutation;
- canonical sponge;
- commitment;
- identity;
- nullifier;
- registry leaf;
- Merkle node;
- patient-prescription binding;
- full depth-4 registry root.

The integrated test set must also cover valid and invalid protocol cases,
including expiry, threshold, registry membership, signature validity,
prescription integrity, and replay protection where applicable.

## 14. Testing

Correctness testing and performance benchmarking are separate workflows.

Correctness testing must run both backend test suites and cross-backend KATs.

The default test workflow must not depend on previously generated benchmark
numbers.

## 15. Benchmark Boundary

Benchmarks must generate fresh measurements on the execution machine.

Where applicable, report:

- compilation;
- witness generation;
- setup/key generation;
- proving;
- verification;
- proof size;
- verification-key size;
- peak memory;
- operating system;
- CPU;
- architecture;
- available memory;
- tool versions; and
- repository commit.

No projected, fabricated, or static benchmark numbers are part of the
artifact.

## 16. Reproducibility Targets

The intended platforms are:

- x86_64 development systems;
- Raspberry Pi 5, 8 GB, ARM64;
- NVIDIA Jetson Orin Nano, JetPack 7.2.1, ARM64.

ARM64 support must be established through actual execution of the pinned
toolchain rather than assumed from source compatibility.

## 17. Protocol Versioning

A change to any of the following constitutes a protocol-level change:

- hash construction;
- domain value;
- field representation;
- input ordering;
- sponge framing;
- registry construction;
- protocol relation.

Such changes require regeneration of dependent KATs, registry fixtures,
authentication paths, and affected test inputs.

## 18. Implementation Status

Verified:

- Poseidon2 t=4 permutation equivalence between TACEO Circom and pinned
  Noir beta.24.
- Canonical six-element sponge execution path across the two backends.

Pending:

- application-level commitment KAT;
- identity KAT;
- nullifier KAT;
- registry-leaf KAT;
- Merkle-node KAT;
- patient-binding KAT;
- regenerated depth-4 registry root;
- final Circom registry migration;
- complete post-migration regression.

Therefore the protocol is not yet fully implementation-frozen.
