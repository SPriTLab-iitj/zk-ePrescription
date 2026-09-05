pragma circom 2.1.6;

include "poseidon2_permutation.circom";

// Raw Poseidon2 sponge hash for Schnorr challenge (N=5, no domain tag).
// Message: [Rx, Ry, PKx, PKy, commitment]
// Rate = 3, capacity = 1, IV = N * 2^64.

template Poseidon2SchnorrChallenge() {
    signal input Rx;
    signal input Ry;
    signal input PKx;
    signal input PKy;
    signal input commitment;

    signal output challenge;

    component p0 = Poseidon2Permutation();
    component p1 = Poseidon2Permutation();

    // N = 5
    // First absorption block (rate = 3):
    // [Rx, Ry, PKx]
    p0.state_in[0] <== Rx;
    p0.state_in[1] <== Ry;
    p0.state_in[2] <== PKx;
    p0.state_in[3] <== 5 * 18446744073709551616;

    // Remaining absorption (2 elements) and final permutation:
    // [PKy, commitment]
    p1.state_in[0] <== p0.state_out[0] + PKy;
    p1.state_in[1] <== p0.state_out[1] + commitment;
    p1.state_in[2] <== p0.state_out[2];
    p1.state_in[3] <== p0.state_out[3];

    challenge <== p1.state_out[0];
}
