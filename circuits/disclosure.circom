pragma circom 2.0.0;

template SelectiveDiscloser() {
    signal input field;
    signal input discloseFlag;

    signal output disclosedField;

    // Constrain discloseFlag to be binary: 0 or 1
    discloseFlag * (discloseFlag - 1) === 0;

    // Enforce: disclosedField = discloseFlag * field
    disclosedField <== discloseFlag * field;
}
