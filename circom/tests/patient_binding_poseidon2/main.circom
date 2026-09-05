pragma circom 2.1.6;

include "../../lib/poseidon2/poseidon2_patient_binding.circom";

template Main() {
    signal input identity_ref;
    signal input commitment;
    signal input expected;

    component pb = Poseidon2PatientBinding();

    pb.identity_ref <== identity_ref;
    pb.commitment <== commitment;

    expected === pb.patient_binding;
}

component main {
    public [
        identity_ref,
        commitment,
        expected
    ]
} = Main();
