pragma circom 2.1.6;

include "../../lib/poseidon2/poseidon2_commitment.circom";

template Main() {
    signal input prescription_id;
    signal input doctor_id;
    signal input medicine_code;
    signal input expiry;
    signal input threshold;
    signal input expected;

    component c = Poseidon2Commitment();

    c.prescription_id <== prescription_id;
    c.doctor_id <== doctor_id;
    c.medicine_code <== medicine_code;
    c.expiry <== expiry;
    c.threshold <== threshold;

    expected === c.commitment;
}

component main {
    public [
        prescription_id,
        doctor_id,
        medicine_code,
        expiry,
        threshold,
        expected
    ]
} = Main();
