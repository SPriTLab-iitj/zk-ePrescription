use common::poseidon2_hash::{registry_leaf_hash, merkle_node_hash};

fn main(
    doctor_id: Field,
    doctor_pubkey_x: Field,
    doctor_pubkey_y: Field,
    sibling0: Field,
    sibling1: Field,
    direction0: bool,
    direction1: bool,
) -> pub [Field; 2] {
    let leaf = registry_leaf_hash(doctor_id, doctor_pubkey_x, doctor_pubkey_y);

    let level0 = if direction0 {
        merkle_node_hash(sibling0, leaf)
    } else {
        merkle_node_hash(leaf, sibling0)
    };

    let root = if direction1 {
        merkle_node_hash(sibling1, level0)
    } else {
        merkle_node_hash(level0, sibling1)
    };

    [leaf, root]
}
