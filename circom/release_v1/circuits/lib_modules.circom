pragma circom 2.1.6;

include "../node_modules/circomlib/circuits/poseidon.circom";

include "../node_modules/circomlib/circuits/comparators.circom";
include "06_schnorr_bjj.circom";
 template Commitment() { signal input prescription_id;
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

template DoctorRegistry() {
    signal input doctor_leaf;
    signal input sibling0;
    signal input sibling1;
    signal input direction0;
    signal input direction1;
    signal input root;

    signal output valid;

    // direction bits must be 0 or 1
    direction0 * (direction0 - 1) === 0;
    direction1 * (direction1 - 1) === 0;

    // --------------------
    // Level 1
    // --------------------
    signal left0;
    signal right0;
    signal l0a;
    signal l0b;
  l0a <== doctor_leaf * (1 - direction0);
    l0b <== sibling0 * direction0;
    left0 <== l0a + l0b;

    signal r0a;
    signal r0b;

    r0a <== doctor_leaf * direction0;
    r0b <== sibling0 * (1 - direction0);
    right0 <== r0a + r0b;

    component hash1 = Poseidon(2);
    hash1.inputs[0] <== left0;
    hash1.inputs[1] <== right0;

    signal h1;
    h1 <== hash1.out;

    // --------------------
    // Level 2
    // --------------------
    signal left1;
    signal right1;
    signal l1a;
  signal l1b;

    l1a <== h1 * (1 - direction1);
    l1b <== sibling1 * direction1;
    left1 <== l1a + l1b;

    signal r1a;
    signal r1b;

    r1a <== h1 * direction1;
    r1b <== sibling1 * (1 - direction1);
    right1 <== r1a + r1b;

    component hash2 = Poseidon(2);
    hash2.inputs[0] <== left1;
    hash2.inputs[1] <== right1;

    signal h2;
    h2 <== hash2.out;

    // root must match
    h2 === root;

    valid <== 1;
}
template SchnorrPlaceholder() {
    // Public / semi-public data
    signal input R;
    signal input pk;
    signal input C;

    // Private witness values
    signal input r;
    signal input sk;
    signal input s;

    // Output flag
    signal output valid;

    // Challenge hash:
    // e = H(R || pk || C)
    component h = Poseidon(3);
    h.inputs[0] <== R;
    h.inputs[1] <== pk;
    h.inputs[2] <== C;

    signal e;
    e <== h.out;
 // Toy response relation:
    // s = r + e * sk
    // This is only a scaffold for the paper and for later replacement.
    s === r + e * sk;

    valid <== 1;
}
template SelectiveDisclosure() {
    signal input medicine_code;
    signal input disclosed_medicine_code;

    signal output valid;

    medicine_code === disclosed_medicine_code;
    valid <== 1;
}
