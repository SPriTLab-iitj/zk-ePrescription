use common::poseidon2_hash::{
    registry_leaf_hash,
    merkle_node_hash,
};

fn main(
    registry_root: pub Field,

    doctor_id: Field,
    doctor_pubkey_x: Field,
    doctor_pubkey_y: Field,

    sibling0: Field,
    sibling1: Field,

    direction0: bool,
    direction1: bool,
) -> pub bool {

    // Step D1
    let leaf = registry_leaf_hash(
        doctor_id,
        doctor_pubkey_x,
        doctor_pubkey_y,
    );

    // Step D2
    let level0 = if direction0 {
        merkle_node_hash(sibling0, leaf)
    } else {
        merkle_node_hash(leaf, sibling0)
    };

// Step D3
let computed_root = if direction1 {
    merkle_node_hash(sibling1, level0)
} else {
    merkle_node_hash(level0, sibling1)
};


// Step D4
assert(computed_root == registry_root);

true
    
}
