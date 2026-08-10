// poseidon2_hash.nr
//
// Standalone Poseidon2 sponge hash for use in circuits, built directly on the
// public `std::hash::poseidon2_permutation` foreign function.
//
// WHY THIS FILE EXISTS:
// Noir's stdlib (v1.0.0-beta.22, and confirmed unchanged on latest master)
// implements a full Poseidon2 sponge as `Poseidon2Hasher` in
// noir_stdlib/src/hash/poseidon2.nr, but the struct is scoped `pub(crate)` —
// it is not accessible from outside the stdlib itself. Only the low-level
// `poseidon2_permutation` primitive is public. This module re-implements the
// sponge wrapper ourselves, calling that public primitive directly.
//
// DEVIATION FROM STDLIB LOGIC (documented intentionally):
// The beta.22 stdlib's tail-absorption loop re-reads from the start of the
// input buffer instead of the unabsorbed tail (`self._state[i]` instead of
// `self._state[absorbed + i]`). This was corrected upstream on master, whose
// own test suite documents the resulting collision risk: two inputs differing
// only in their trailing elements could hash to the same digest if the buggy
// version were used. Since this hash is used for commitments and nullifiers,
// where tail-collision resistance directly matters for replay protection,
// this implementation uses the CORRECTED absorption logic (matching current
// master), not the exact beta.22 logic. This is a deliberate choice, not an
// oversight — see project methodology notes.
//
// Parameters (RATE=3, CAPACITY=1, state size=4) match the current BN254
// Poseidon2 configuration used by both beta.22 and master.

global HASH_RATE: u32 = 3;

// -----------------------------------------------------------------------
// Shared sponge core
// -----------------------------------------------------------------------

fn poseidon2_hash<let N: u32>(inputs: [Field; N]) -> Field {
    let iv: Field = (N as Field) * 18446744073709551616;
    let mut state: [Field; 4] = [0, 0, 0, iv];

    let full_chunks: u32 = N / HASH_RATE;

    for i in 0..full_chunks {
        state[0] += inputs[i * HASH_RATE];
        state[1] += inputs[i * HASH_RATE + 1];
        state[2] += inputs[i * HASH_RATE + 2];
        state = std::hash::poseidon2_permutation(state);
    }

    let absorbed: u32 = full_chunks * HASH_RATE;
    let remainder: u32 = N - absorbed;
    for i in 0..remainder {
        state[i] += inputs[absorbed + i];
    }

    std::hash::poseidon2_permutation(state)[0]
}

// -----------------------------------------------------------------------
// Domain separation
// -----------------------------------------------------------------------

global DOMAIN_COMMITMENT: Field = 1;
global DOMAIN_IDENTITY: Field = 2;
global DOMAIN_NULLIFIER: Field = 3;
global DOMAIN_REGISTRY_LEAF: Field = 4;
global DOMAIN_MERKLE_NODE: Field = 5;

fn domain_tagged_hash<let N: u32>(domain: Field, inputs: [Field; N]) -> Field {
    let mut tagged: [Field; N + 1] = [0; N + 1];
    tagged[0] = domain;
    for i in 0..N {
        tagged[i + 1] = inputs[i];
    }
    poseidon2_hash(tagged)
}

// Public wrappers

pub fn commitment_hash<let N: u32>(inputs: [Field; N]) -> Field {
    domain_tagged_hash(DOMAIN_COMMITMENT, inputs)
}

pub fn identity_hash<let N: u32>(inputs: [Field; N]) -> Field {
    domain_tagged_hash(DOMAIN_IDENTITY, inputs)
}

pub fn nullifier_hash<let N: u32>(inputs: [Field; N]) -> Field {
    domain_tagged_hash(DOMAIN_NULLIFIER, inputs)
}

pub fn registry_leaf_hash(doctor_id: Field, pubkey_x: Field, pubkey_y: Field) -> Field {
    domain_tagged_hash(DOMAIN_REGISTRY_LEAF, [doctor_id, pubkey_x, pubkey_y])
}

pub fn merkle_node_hash(left: Field, right: Field) -> Field {
    domain_tagged_hash(DOMAIN_MERKLE_NODE, [left, right])
}

// -----------------------------------------------------------------------
// Tests
// -----------------------------------------------------------------------
mod tests {
    use super::{
        commitment_hash,
        identity_hash,
        merkle_node_hash,
        nullifier_hash,
        poseidon2_hash,
        registry_leaf_hash,
    };

    #[test]
    fn matches_known_digest_len_5() {
        let inputs: [Field; 5] = [1, 2, 3, 4, 5];
        let digest = poseidon2_hash(inputs);
        assert(digest == 0x2247be7014a54d17342a7ef677f58d28877780d203860396967f5d0a18d259db);
    }

    #[test]
    fn domain_separation_holds_on_identical_input() {
        let inputs: [Field; 4] = [111, 222, 333, 444];
        let c = commitment_hash(inputs);
        let idb = identity_hash(inputs);
        let n = nullifier_hash(inputs);

        assert(c != idb);
        assert(c != n);
        assert(idb != n);
    }

    #[test]
    fn registry_leaf_hash_deterministic_and_sensitive() {
        let a = registry_leaf_hash(1, 100, 200);
        let b = registry_leaf_hash(1, 100, 200);
        assert(a == b);

        let c = registry_leaf_hash(1, 100, 999);
        assert(a != c);

        let d = registry_leaf_hash(2, 100, 200);
        assert(a != d);
    }

    #[test]
    fn leaf_and_node_are_domain_separated() {
        let leaf = registry_leaf_hash(10, 20, 30);
        let node = merkle_node_hash(10, 20);
        assert(leaf != node);
    }

    #[test]
    fn merkle_node_hash_order_sensitive() {
        let a = merkle_node_hash(111, 222);
        let b = merkle_node_hash(222, 111);
        assert(a != b);
    }
}
