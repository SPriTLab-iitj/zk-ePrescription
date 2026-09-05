pragma circom 2.1.6;

include "poseidon2_permutation.circom";

// Domain-separated registry leaf hash.
// Message: [doctor_id, pubkey_x, pubkey_y]
// Domain = 4, rate = 3, capacity = 1, IV = N * 2^64.

template Poseidon2RegistryLeaf() {
    signal input doctor_id;
    signal input pubkey_x;
    signal input pubkey_y;

    signal output leaf;

    component p0 = Poseidon2Permutation();
    component p1 = Poseidon2Permutation();

    // N = 4 (domain tag + 3 message elements)
    // First absorption block:
    // [domain, doctor_id, pubkey_x]
    p0.state_in[0] <== 4;
    p0.state_in[1] <== doctor_id;
    p0.state_in[2] <== pubkey_x;
    p0.state_in[3] <== 4 * 18446744073709551616;

    // Remaining input:
    // [pubkey_y]
    p1.state_in[0] <== p0.state_out[0] + pubkey_y;
    p1.state_in[1] <== p0.state_out[1];
    p1.state_in[2] <== p0.state_out[2];
    p1.state_in[3] <== p0.state_out[3];

    leaf <== p1.state_out[0];
}
