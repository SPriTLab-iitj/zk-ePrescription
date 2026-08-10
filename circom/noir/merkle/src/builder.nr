use crate::hash::hash_node;

type TreeSize<let LEAF_COUNT: u32>: u32 = 2 * LEAF_COUNT - 1;

/// Reference/off-chain Merkle tree builder.
///
/// This is intentionally unconstrained: it is a witness/reference helper,
/// not part of the proving circuit.
pub unconstrained fn build_tree<let LEAF_COUNT: u32>(
    leaves: [Field; LEAF_COUNT],
) -> [Field; TreeSize::<LEAF_COUNT>] {
    let mut tree = [0; TreeSize::<LEAF_COUNT>];

    for i in 0..LEAF_COUNT {
        tree[i] = leaves[i];
    }

    let mut level_start = 0;
    let mut level_size = LEAF_COUNT;
    let mut next_start = LEAF_COUNT;

    while level_size > 1 {
        let parent_count = level_size / 2;

        for j in 0..parent_count {
            let left = tree[level_start + 2 * j];
            let right = tree[level_start + 2 * j + 1];
            tree[next_start + j] = hash_node(left, right);
        }

        level_start = next_start;
        next_start = next_start + parent_count;
        level_size = parent_count;
    }

    tree
}
