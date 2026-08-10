/// Extracts the authentication path for a depth-4 tree.
pub fn extract_auth_path_depth4(
    tree: [Field; 31],
    doctor_index: u32,
) -> (Field, [Field; 4], [Field; 4]) {
    let leaf_count: u32 = 16;
    let total_nodes: u32 = 31;

    assert(doctor_index < leaf_count);

    let root = tree[total_nodes - 1];

    let mut path_elements = [0; 4];
    let mut path_indices = [0; 4];

    let mut level_start: u32 = 0;
    let mut level_size: u32 = leaf_count;
    let mut current_index: u32 = doctor_index;

    for level in 0..4 {
        let sibling_index: u32 = if current_index % 2 == 0 {
            current_index + 1
        } else {
            current_index - 1
        };

        path_elements[level] = tree[level_start + sibling_index];

        path_indices[level] = if current_index % 2 == 0 {
            0
        } else {
            1
        };

        current_index /= 2;
        level_start += level_size;
        level_size /= 2;
    }

    (root, path_elements, path_indices)
}
