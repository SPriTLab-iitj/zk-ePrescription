// Heap layout used by tree_builder.nr:
//
// tree[0..16]  = leaves
// tree[16..24] = level 1
// tree[24..28] = level 2
// tree[28..30] = level 3
// tree[30]     = root
//
// Returns:
// [ selected_leaf,
//   sibling0,
//   sibling1,
//   sibling2,
//   sibling3,
//   direction0,
//   direction1,
//   direction2,
//   direction3,
//   root ]

pub fn authentication_path(
    doctor_index: u32,
    tree: [Field; 31],
) -> [Field; 10] {
    let leaf_index = doctor_index as u32;

    let level1_index = 16 + (leaf_index / 2);
    let level2_index = 24 + (leaf_index / 4);
    let level3_index = 28 + (leaf_index / 8);

    let sibling0 = tree[if leaf_index % 2 == 0 {
        leaf_index + 1
    } else {
        leaf_index - 1
    }];

    let sibling1 = tree[if (leaf_index / 2) % 2 == 0 {
        level1_index + 1
    } else {
        level1_index - 1
    }];

    let sibling2 = tree[if (leaf_index / 4) % 2 == 0 {
        level2_index + 1
    } else {
        level2_index - 1
    }];

    let sibling3 = tree[if (leaf_index / 8) % 2 == 0 {
        level3_index + 1
    } else {
        level3_index - 1
    }];

    [
        tree[leaf_index],
        sibling0,
        sibling1,
        sibling2,
        sibling3,
        (leaf_index % 2) as Field,
        ((leaf_index / 2) % 2) as Field,
        ((leaf_index / 4) % 2) as Field,
        ((leaf_index / 8) % 2) as Field,
        tree[30],
    ]
}
