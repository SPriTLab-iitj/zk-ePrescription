pragma circom 2.1.6;

include "poseidon2_permutation.circom";

// Domain-separated patient-prescription binding.
// Message: [identity_ref, commitment]
// Domain = 6, rate = 3, capacity = 1, IV = N * 2^64.

template Poseidon2PatientBinding() {
    signal input identity_ref;
    signal input commitment;

    signal output patient_binding;

    component p0 = Poseidon2Permutation();
    component p1 = Poseidon2Permutation();

    // N = 3
    // Initial state: [0, 0, 0, 3 * 2^64]
    // Absorb: [domain, identity_ref, commitment]
    p0.state_in[0] <== 6;
    p0.state_in[1] <== identity_ref;
    p0.state_in[2] <== commitment;
    p0.state_in[3] <== 3 * 18446744073709551616;

    // Final permutation after the complete block.
    p1.state_in[0] <== p0.state_out[0];
    p1.state_in[1] <== p0.state_out[1];
    p1.state_in[2] <== p0.state_out[2];
    p1.state_in[3] <== p0.state_out[3];

    patient_binding <== p1.state_out[0];
}
