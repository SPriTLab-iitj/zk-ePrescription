pragma circom 2.1.6;

include "../../lib/poseidon2/poseidon2_nullifier.circom";

template Main() {
    signal input patient_secret;
    signal input commitment;
    signal input slot_index;
    signal input expected;

    component n = Poseidon2Nullifier();

    n.patient_secret <== patient_secret;
    n.commitment <== commitment;
    n.slot_index <== slot_index;

    expected === n.nullifier;
}

component main {
    public [
        patient_secret,
        commitment,
        slot_index,
        expected
    ]
} = Main();
