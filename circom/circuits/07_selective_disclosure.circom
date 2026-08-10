pragma circom 2.1.6;

template SelectiveDisclosure() {
    signal input medicine_code;
    signal input disclosed_medicine_code;

    signal output valid;

    medicine_code === disclosed_medicine_code;
    valid <== 1;
}

component main = SelectiveDisclosure();
