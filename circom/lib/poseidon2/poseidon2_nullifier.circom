pragma circom 2.1.6;

include "poseidon2_permutation.circom";

// Domain-separated nullifier hash.
// Message: [patient_secret, commitment, slot_index]
// Domain = 3, rate = 3, capacity = 1, IV = N * 2^64.

template Poseidon2Nullifier() {
    signal input patient_secret;
    signal input commitment;
    signal input slot_index;

    signal output nullifier;

    component p0 = Poseidon2Permutation();
    component p1 = Poseidon2Permutation();

    // N = 4
    // Initial state: [0, 0, 0, 4 * 2^64]
    //
    // First absorption block:
    // [domain, patient_secret, commitment]
    p0.state_in[0] <== 3;
    p0.state_in[1] <== patient_secret;
    p0.state_in[2] <== commitment;
    p0.state_in[3] <== 4 * 18446744073709551616;

    // Remaining input:
    // [slot_index]
    p1.state_in[0] <== p0.state_out[0] + slot_index;
    p1.state_in[1] <== p0.state_out[1];
    p1.state_in[2] <== p0.state_out[2];
    p1.state_in[3] <== p0.state_out[3];

    nullifier <== p1.state_out[0];
}
