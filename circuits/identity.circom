pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/poseidon.circom";

template IdentityBinder() {
    signal input patientSecret;
    signal input domainSeparator;

    signal output identityToken;

    component hasher = Poseidon(2);
    hasher.inputs[0] <== patientSecret;
    hasher.inputs[1] <== domainSeparator;

    identityToken <== hasher.out;
}
