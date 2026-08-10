pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/poseidon.circom";

template CommitmentHasher() {
    signal input prescriptionId;
    signal input identityToken;
    signal input medicineCode;
    signal input medicineQty;
    signal input expiry;
    signal input threshold;
    signal input registryVersion;

    signal output commitment;

    component hasher = Poseidon(7);
    hasher.inputs[0] <== prescriptionId;
    hasher.inputs[1] <== identityToken;
    hasher.inputs[2] <== medicineCode;
    hasher.inputs[3] <== medicineQty;
    hasher.inputs[4] <== expiry;
    hasher.inputs[5] <== threshold;
    hasher.inputs[6] <== registryVersion;

    commitment <== hasher.out;
}
