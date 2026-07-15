pub fn extract_auth_path(
    tree: [Field; 7],
    doctor_index: u32,
) -> [Field; 5] {

    // Frozen tree layout
    //
    // tree[0] = Leaf0
    // tree[1] = Leaf1
    // tree[2] = Leaf2
    // tree[3] = Leaf3
    // tree[4] = Node0
    // tree[5] = Node1
    // tree[6] = Registry Root

    let leaf0 = tree[0];
    let leaf1 = tree[1];
    let leaf2 = tree[2];
    let leaf3 = tree[3];

    let node0 = tree[4];
    let node1 = tree[5];

    let root = tree[6];

    if doctor_index == 0 {
        // Doctor 0
        //
        // Leaf0
        //  ├── sibling = Leaf1
        //  └── parent sibling = Node1

        [
            root,
            leaf1,
            node1,
            0, // Direction0 = Left
            0, // Direction1 = Left
        ]

    } else if doctor_index == 1 {
        // Doctor 1
        //
        // Leaf1
        //  ├── sibling = Leaf0
        //  └── parent sibling = Node1

        [
            root,
            leaf0,
            node1,
            1, // Direction0 = Right
            0, // Direction1 = Left
        ]

    } else if doctor_index == 2 {
        // Doctor 2
        //
        // Leaf2
        //  ├── sibling = Leaf3
        //  └── parent sibling = Node0

        [
            root,
            leaf3,
            node0,
            0, // Direction0 = Left
            1, // Direction1 = Right
        ]

    } else if doctor_index == 3 {
        // Doctor 3
        //
        // Leaf3
        //  ├── sibling = Leaf2
        //  └── parent sibling = Node0

        [
            root,
            leaf2,
            node0,
            1, // Direction0 = Right
            1, // Direction1 = Right
        ]

    } else {

        // Invalid doctor index.
        // (For this prototype we return zeros.
        // Future versions may constrain doctor_index in-circuit.)

        [
            0,
            0,
            0,
            0,
            0,
        ]
    }
}
