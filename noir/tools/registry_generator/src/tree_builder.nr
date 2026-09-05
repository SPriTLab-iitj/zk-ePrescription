use common::poseidon2_hash::{
    registry_leaf_hash,
    merkle_node_hash,
};

// Builds a complete 16-leaf / depth-4 binary Merkle tree.
//
// Heap layout:
//   tree[0..16]  = leaves
//   tree[16..24] = level 1
//   tree[24..28] = level 2
//   tree[28..30] = level 3
//   tree[30]     = root
//
// Returns all 31 nodes so authentication paths can be derived
// without duplicating the hashing logic.
pub fn build_tree(
    doctor_ids: [Field; 16],
    doctor_pubkey_xs: [Field; 16],
    doctor_pubkey_ys: [Field; 16],
) -> [Field; 31] {
    let mut tree = [0; 31];

    // Leaves.
    for i in 0..16 {
        tree[i] = registry_leaf_hash(
            doctor_ids[i],
            doctor_pubkey_xs[i],
            doctor_pubkey_ys[i],
        );
    }

    // Internal levels.
    let mut level_start = 0;
    let mut level_width = 16;
    let mut output_start = 16;

    for _level in 0..4 {
        for j in 0..(level_width / 2) {
            tree[output_start + j] = merkle_node_hash(
                tree[level_start + 2 * j],
                tree[level_start + 2 * j + 1],
            );
        }

        level_start = output_start;
        level_width = level_width / 2;
        output_start = output_start + level_width;
    }

    tree
}
