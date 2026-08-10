pragma circom 2.1.6;

include "../node_modules/circomlib/circuits/poseidon.circom";
include "../node_modules/circomlib/circuits/comparators.circom";
include "06_schnorr_bjj.circom";
include "05_doctor_registry_merkle_lib.circom";

template Commitment() {
    signal input prescription_id;
    signal input doctor_id;
    signal input medicine_code;
    signal input expiry;
    signal input threshold;

    signal output commitment;

    component poseidon = Poseidon(5);
    poseidon.inputs[0] <== prescription_id;
    poseidon.inputs[1] <== doctor_id;
    poseidon.inputs[2] <== medicine_code;
    poseidon.inputs[3] <== expiry;
    poseidon.inputs[4] <== threshold;

    commitment <== poseidon.out;
}

template IdentityBinding() {
    signal input patient_secret;
    signal output identity_ref;

    component poseidon = Poseidon(1);
    poseidon.inputs[0] <== patient_secret;
    identity_ref <== poseidon.out;
}

template Nullifier() {
    signal input patient_secret;
    signal input commitment;
    signal input slot_index;

    signal output nullifier;

    component poseidon = Poseidon(3);
    poseidon.inputs[0] <== patient_secret;
    poseidon.inputs[1] <== commitment;
    poseidon.inputs[2] <== slot_index;

    nullifier <== poseidon.out;
}

template ThresholdCheck() {
    signal input slot_index;
    signal input threshold;

    signal output valid;

    component lessThan = LessThan(32);
    lessThan.in[0] <== slot_index;
    lessThan.in[1] <== threshold;

    valid <== lessThan.out;
}

template SelectiveDisclosure() {
    signal input medicine_code;
    signal input disclosed_medicine_code;

    signal output valid;

    medicine_code === disclosed_medicine_code;
    valid <== 1;
}
