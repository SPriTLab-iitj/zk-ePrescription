mod tree_builder;
mod auth_path;

use common::poseidon2_hash::registry_leaf_hash;
use tree_builder::build_tree_depth4;
use auth_path::extract_auth_path_depth4;

/// Generates a depth-4 registry root and authentication path.
/// Doctor index is 0-based.
fn main(
    doctor_ids: [Field; 16],
    doctor_pubkey_xs: [Field; 16],
    doctor_pubkey_ys: [Field; 16],
    doctor_index: u32,
) -> pub [Field; 9] {
    let mut leaf_hashes = [0; 16];

    for i in 0..16 {
        leaf_hashes[i] = registry_leaf_hash(
            doctor_ids[i],
            doctor_pubkey_xs[i],
            doctor_pubkey_ys[i],
        );
    }

    let tree = build_tree_depth4(leaf_hashes);
    let (registry_root, path_elements, path_indices) =
        extract_auth_path_depth4(tree, doctor_index);

    [
        registry_root,
        path_elements[0],
        path_elements[1],
        path_elements[2],
        path_elements[3],
        path_indices[0],
        path_indices[1],
        path_indices[2],
        path_indices[3],
    ]
}
