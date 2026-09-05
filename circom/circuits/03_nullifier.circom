pragma circom 2.1.6;

include "lib_modules.circom";

template NullifierCircuit() {
    signal input patient_secret;
    signal input commitment;
    signal input slot_index;

    signal output nullifier;

    component n = Nullifier();

    n.patient_secret <== patient_secret;
    n.commitment <== commitment;
    n.slot_index <== slot_index;

    nullifier <== n.nullifier;
}

component main = NullifierCircuit();
