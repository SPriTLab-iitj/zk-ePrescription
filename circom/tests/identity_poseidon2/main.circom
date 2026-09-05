pragma circom 2.1.6;

include "../../lib/poseidon2/poseidon2_identity.circom";

template Main() {
    signal input patient_secret;
    signal input expected;

    component i = Poseidon2Identity();

    i.patient_secret <== patient_secret;

    expected === i.identity_ref;
}

component main {
    public [
        patient_secret,
        expected
    ]
} = Main();
