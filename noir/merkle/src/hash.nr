use common::poseidon2_hash::merkle_node_hash;

/// Hash two Merkle child nodes into their parent node.
///
/// This module deliberately does not define application-specific
/// leaf hashing. The Merkle library operates only on already-hashed
/// leaf values and internal node values.
pub fn hash_node(left: Field, right: Field) -> Field {
    merkle_node_hash(left, right)
}
