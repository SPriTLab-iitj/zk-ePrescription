pragma circom 2.1.6;

include "poseidon2_permutation.circom";

// Domain-separated Merkle internal node hash.
// Message: [left, right]
// Domain = 5, rate = 3, capacity = 1, IV = N * 2^64.

template Poseidon2MerkleNode() {
    signal input left;
    signal input right;

    signal output node;

    component p0 = Poseidon2Permutation();
    component p1 = Poseidon2Permutation();

    // N = 3
    // Initial state: [0, 0, 0, 3 * 2^64]
    // Absorb: [domain, left, right]
    p0.state_in[0] <== 5;
    p0.state_in[1] <== left;
    p0.state_in[2] <== right;
    p0.state_in[3] <== 3 * 18446744073709551616;

    // Final permutation after the complete block.
    p1.state_in[0] <== p0.state_out[0];
    p1.state_in[1] <== p0.state_out[1];
    p1.state_in[2] <== p0.state_out[2];
    p1.state_in[3] <== p0.state_out[3];

    node <== p1.state_out[0];
}
