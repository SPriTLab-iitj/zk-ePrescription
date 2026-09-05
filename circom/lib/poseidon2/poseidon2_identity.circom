pragma circom 2.1.6;

include "poseidon2_permutation.circom";

// Domain-separated identity hash.
// Message: [patient_secret]
// Domain = 2, rate = 3, capacity = 1, IV = N * 2^64.

template Poseidon2Identity() {
    signal input patient_secret;
    signal output identity_ref;

    component p = Poseidon2Permutation();

    // N = 2
    // Initial state: [0, 0, 0, 2 * 2^64]
    // Absorb [domain, patient_secret].
    p.state_in[0] <== 2;
    p.state_in[1] <== patient_secret;
    p.state_in[2] <== 0;
    p.state_in[3] <== 2 * 18446744073709551616;

    identity_ref <== p.state_out[0];
}
