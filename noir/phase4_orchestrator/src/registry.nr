use common::poseidon2_hash::{
    registry_leaf_hash,
    merkle_node_hash,
};

/// Verifies that the doctor's public key is a member of the
/// authorized registry root using a fixed depth-2 Merkle path.
pub fn verify_registry(
    registry_root: Field,
    doctor_id: Field,
    doctor_pubkey_x: Field,
    doctor_pubkey_y: Field,
    sibling0: Field,
    sibling1: Field,
    direction0: bool,
    direction1: bool,
) -> bool {
    let leaf = registry_leaf_hash(
        doctor_id,
        doctor_pubkey_x,
        doctor_pubkey_y,
    );

    let level0 = if direction0 {
        merkle_node_hash(sibling0, leaf)
    } else {
        merkle_node_hash(leaf, sibling0)
    };

    let computed_root = if direction1 {
        merkle_node_hash(sibling1, level0)
    } else {
        merkle_node_hash(level0, sibling1)
    };

    computed_root == registry_root
}
