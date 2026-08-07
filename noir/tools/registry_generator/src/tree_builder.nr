use common::poseidon2_hash::merkle_node_hash;

/// Builds a flattened Merkle tree from 16 leaf hashes.
///
/// Tree layout:
/// leaves:  0..15
/// level 1: 16..23
/// level 2: 24..27
/// level 3: 28..29
/// root:    30
pub fn build_tree_depth4(leaf_hashes: [Field; 16]) -> [Field; 31] {
    let leaf0 = leaf_hashes[0];
    let leaf1 = leaf_hashes[1];
    let leaf2 = leaf_hashes[2];
    let leaf3 = leaf_hashes[3];
    let leaf4 = leaf_hashes[4];
    let leaf5 = leaf_hashes[5];
    let leaf6 = leaf_hashes[6];
    let leaf7 = leaf_hashes[7];
    let leaf8 = leaf_hashes[8];
    let leaf9 = leaf_hashes[9];
    let leaf10 = leaf_hashes[10];
    let leaf11 = leaf_hashes[11];
    let leaf12 = leaf_hashes[12];
    let leaf13 = leaf_hashes[13];
    let leaf14 = leaf_hashes[14];
    let leaf15 = leaf_hashes[15];

    let node0 = merkle_node_hash(leaf0, leaf1);
    let node1 = merkle_node_hash(leaf2, leaf3);
    let node2 = merkle_node_hash(leaf4, leaf5);
    let node3 = merkle_node_hash(leaf6, leaf7);
    let node4 = merkle_node_hash(leaf8, leaf9);
    let node5 = merkle_node_hash(leaf10, leaf11);
    let node6 = merkle_node_hash(leaf12, leaf13);
    let node7 = merkle_node_hash(leaf14, leaf15);

    let node8 = merkle_node_hash(node0, node1);
    let node9 = merkle_node_hash(node2, node3);
    let node10 = merkle_node_hash(node4, node5);
    let node11 = merkle_node_hash(node6, node7);

    let node12 = merkle_node_hash(node8, node9);
    let node13 = merkle_node_hash(node10, node11);

    let root = merkle_node_hash(node12, node13);

    [
        leaf0, leaf1, leaf2, leaf3, leaf4, leaf5, leaf6, leaf7,
        leaf8, leaf9, leaf10, leaf11, leaf12, leaf13, leaf14, leaf15,
        node0, node1, node2, node3, node4, node5, node6, node7,
        node8, node9, node10, node11,
        node12, node13,
        root,
    ]
}
