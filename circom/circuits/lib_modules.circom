pragma circom 2.1.6;

include "../node_modules/circomlib/circuits/comparators.circom";
include "06_schnorr_bjj.circom";
include "05_doctor_registry_merkle_lib.circom";

include "../lib/poseidon2/poseidon2_commitment.circom";
include "../lib/poseidon2/poseidon2_identity.circom";
include "../lib/poseidon2/poseidon2_nullifier.circom";

template Commitment() {
    signal input prescription_id;
    signal input doctor_id;
    signal input medicine_code;
    signal input expiry;
    signal input threshold;

    signal output commitment;

    component c = Poseidon2Commitment();

    c.prescription_id <== prescription_id;
    c.doctor_id <== doctor_id;
    c.medicine_code <== medicine_code;
    c.expiry <== expiry;
    c.threshold <== threshold;

    commitment <== c.commitment;
}

template IdentityBinding() {
    signal input patient_secret;
    signal output identity_ref;

    component i = Poseidon2Identity();

    i.patient_secret <== patient_secret;

    identity_ref <== i.identity_ref;
}

template Nullifier() {
    signal input patient_secret;
    signal input commitment;
    signal input slot_index;

    signal output nullifier;

    component n = Poseidon2Nullifier();

    n.patient_secret <== patient_secret;
    n.commitment <== commitment;
    n.slot_index <== slot_index;

    nullifier <== n.nullifier;
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
