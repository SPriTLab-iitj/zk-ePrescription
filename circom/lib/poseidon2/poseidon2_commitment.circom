pragma circom 2.1.6;

include "poseidon2_permutation.circom";

// Domain-separated commitment hash.
// Message: [prescription_id, doctor_id, medicine_code, expiry, threshold]
// Domain = 1, rate = 3, capacity = 1, IV = N * 2^64.

template Poseidon2Commitment() {
    signal input prescription_id;
    signal input doctor_id;
    signal input medicine_code;
    signal input expiry;
    signal input threshold;

    signal output commitment;

    component p0 = Poseidon2Permutation();
    component p1 = Poseidon2Permutation();
    component p2 = Poseidon2Permutation();

    // First absorption block:
    // [domain, prescription_id, doctor_id]
    p0.state_in[0] <== 1;
    p0.state_in[1] <== prescription_id;
    p0.state_in[2] <== doctor_id;
    p0.state_in[3] <== 6 * 18446744073709551616;

    // Second absorption block:
    // [medicine_code, expiry, threshold]
    p1.state_in[0] <== p0.state_out[0] + medicine_code;
    p1.state_in[1] <== p0.state_out[1] + expiry;
    p1.state_in[2] <== p0.state_out[2] + threshold;
    p1.state_in[3] <== p0.state_out[3];

    // Final permutation.
    p2.state_in[0] <== p1.state_out[0];
    p2.state_in[1] <== p1.state_out[1];
    p2.state_in[2] <== p1.state_out[2];
    p2.state_in[3] <== p1.state_out[3];

    commitment <== p2.state_out[0];
}
