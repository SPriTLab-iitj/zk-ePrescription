use crate::types::MerklePath;

type TreeSize<let LEAF_COUNT: u32>: u32 = 2 * LEAF_COUNT - 1;

/// Reference/off-chain authentication path extractor.
///
/// This is intentionally unconstrained: it is a witness/reference helper,
/// not part of the proving circuit.
pub unconstrained fn extract_auth_path<let LEAF_COUNT: u32, let PATH_LEN: u32>(
    tree: [Field; TreeSize::<LEAF_COUNT>],
    leaf_index: u32,
) -> (MerklePath<PATH_LEN>, Field) {
    let mut path_hashes = [0; PATH_LEN];
    let mut path_dirs = [0; PATH_LEN];

    let mut current_index = leaf_index;
    let mut level_start = 0;
    let mut level_width = LEAF_COUNT;
    let mut path_pos = 0;

    while level_width > 1 {
        let is_left = current_index % 2 == 0;
        let sibling_offset = if is_left {
            current_index + 1
        } else {
            current_index - 1
        };

        path_hashes[path_pos] = tree[level_start + sibling_offset];
        path_dirs[path_pos] = if is_left { 0 } else { 1 };

        current_index = current_index / 2;
        level_start = level_start + level_width;
        level_width = level_width / 2;
        path_pos = path_pos + 1;
    }

    (
        MerklePath {
            hashes: path_hashes,
            dirs: path_dirs,
        },
        tree[TreeSize::<LEAF_COUNT> - 1],
    )
}
