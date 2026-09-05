pragma circom 2.1.6;

include "lib_modules.circom";

template EPrescriptionMain() {
    signal input prescription_id;
    signal input doctor_id;
    signal input medicine_code;
    signal input current_date;
    signal input expiry;
    signal input threshold;

    signal input patient_secret;
    signal input slot_index;

    signal input doctor_leaf;
    signal input pathElements[4];
    signal input pathIndices[4];
    signal input root;

    signal output commitment_out;
    signal output identity_ref_out;
    signal output nullifier_out;

    signal input Rx;
    signal input Ry;
    signal input PKx;
    signal input PKy;
    signal input s;

    component commitment = Commitment();
    commitment.prescription_id <== prescription_id;
    commitment.doctor_id <== doctor_id;
    commitment.medicine_code <== medicine_code;
    commitment.expiry <== expiry;
    commitment.threshold <== threshold;
    commitment_out <== commitment.commitment;

    component identity = IdentityBinding();
    identity.patient_secret <== patient_secret;
    identity_ref_out <== identity.identity_ref;

    component nullifier = Nullifier();
    nullifier.patient_secret <== patient_secret;
    nullifier.commitment <== commitment.commitment;
    nullifier.slot_index <== slot_index;
    nullifier_out <== nullifier.nullifier;

    component threshold_check = ThresholdCheck();
    threshold_check.slot_index <== slot_index;
    threshold_check.threshold <== threshold;
    threshold_check.valid === 1;

    component registry = DoctorRegistry(4);
    registry.doctor_id <== doctor_id;
    registry.pubkey_x <== PKx;
    registry.pubkey_y <== PKy;
    registry.doctor_leaf <== doctor_leaf;
    registry.root <== root;
    for (var i = 0; i < 4; i++) {
        registry.pathElements[i] <== pathElements[i];
        registry.pathIndices[i] <== pathIndices[i];
    }
    registry.valid === 1;

    component expiry_check = LessEqThan(32);
    expiry_check.in[0] <== current_date;
    expiry_check.in[1] <== expiry;
    expiry_check.out === 1;

    component sig = SchnorrBJJ();
    sig.Rx <== Rx;
    sig.Ry <== Ry;
    sig.PKx <== PKx;
    sig.PKy <== PKy;
    sig.C <== commitment.commitment;
    sig.s <== s;
    sig.valid === 1;
}

component main {public [root]} = EPrescriptionMain();
