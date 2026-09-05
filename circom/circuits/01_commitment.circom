pragma circom 2.1.6;

include "lib_modules.circom";

template CommitmentCircuit() {
    signal input prescription_id;
    signal input doctor_id;
    signal input medicine_code;
    signal input expiry;
    signal input threshold;

    signal output commitment;

    component c = Commitment();

    c.prescription_id <== prescription_id;
    c.doctor_id <== doctor_id;
    c.medicine_code <== medicine_code;
    c.expiry <== expiry;
    c.threshold <== threshold;

    commitment <== c.commitment;
}

component main = CommitmentCircuit();
