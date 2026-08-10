pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/poseidon.circom";

template NullifierDeriver() {
    signal input patientSecret;
    signal input commitment;
    signal input redemptionIndex;
    signal input domainSeparator;

    signal output nullifier;

    component hasher = Poseidon(4);
    hasher.inputs[0] <== patientSecret;
    hasher.inputs[1] <== commitment;
    hasher.inputs[2] <== redemptionIndex;
    hasher.inputs[3] <== domainSeparator;

    nullifier <== hasher.out;
}
