pragma circom 2.1.6;

include "../node_modules/circomlib/circuits/poseidon.circom";

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

component main {public [root]} = DoctorRegistry();
