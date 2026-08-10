pragma circom 2.1.6;

include "../node_modules/circomlib/circuits/poseidon.circom";

// Placeholder Schnorr-style signature shell.
// This is NOT a full elliptic-curve Schnorr verifier yet.
// It only fixes the inputs/outputs and challenge flow.

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

component main = SchnorrPlaceholder();
