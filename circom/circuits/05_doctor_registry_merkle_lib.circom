pragma circom 2.1.6;

include "../lib/poseidon2/poseidon2_registry_leaf.circom";
include "../lib/poseidon2/poseidon2_merkle.circom";

template DoctorRegistry(DEPTH) {
    signal input doctor_id;
    signal input pubkey_x;
    signal input pubkey_y;
    signal input doctor_leaf;
    signal input pathElements[DEPTH];
    signal input pathIndices[DEPTH];
    signal input root;

    signal output valid;

    signal currentHash[DEPTH + 1];
    signal left[DEPTH];
    signal right[DEPTH];
    signal leftA[DEPTH];
    signal leftB[DEPTH];
    signal rightA[DEPTH];
    signal rightB[DEPTH];

    component leaf_hash = Poseidon2RegistryLeaf();
    leaf_hash.doctor_id <== doctor_id;
    leaf_hash.pubkey_x <== pubkey_x;
    leaf_hash.pubkey_y <== pubkey_y;
    leaf_hash.leaf === doctor_leaf;

    component hash[DEPTH];

    currentHash[0] <== doctor_leaf;

    for (var i = 0; i < DEPTH; i++) {
        pathIndices[i] * (pathIndices[i] - 1) === 0;

        leftA[i] <== currentHash[i] * (1 - pathIndices[i]);
        leftB[i] <== pathElements[i] * pathIndices[i];
        left[i] <== leftA[i] + leftB[i];

        rightA[i] <== currentHash[i] * pathIndices[i];
        rightB[i] <== pathElements[i] * (1 - pathIndices[i]);
        right[i] <== rightA[i] + rightB[i];

        hash[i] = Poseidon2MerkleNode();
        hash[i].left <== left[i];
        hash[i].right <== right[i];

        currentHash[i + 1] <== hash[i].node;
    }

    currentHash[DEPTH] === root;
    valid <== 1;
}
