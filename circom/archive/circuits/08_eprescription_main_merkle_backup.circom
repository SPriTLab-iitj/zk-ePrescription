pragma circom 2.1.6;

include "lib_modules.circom";

template EPrescriptionMain() {

    // Prescription fields
    signal input prescription_id;
    signal input doctor_id;
    signal input medicine_code;
    signal input current_date;
    signal input expiry;
    signal input threshold;

    // Patient
    signal input patient_secret;
    signal input slot_index;

    // Doctor Registry
    signal input doctor_leaf;
    signal input sibling0;
    signal input sibling1;
    signal input direction0;
    signal input direction1;
    signal input root;
    // Selective disclosure
    signal input disclosed_medicine_code;
    // Outputs
    signal output commitment_out;
    signal output identity_ref_out;
    signal output nullifier_out;

    // Schnorr Signature
    signal input Rx;
    signal input Ry;
    signal input PKx;
    signal input PKy;
    signal input s;
    // Commitment
    component commitment = Commitment();
    commitment.prescription_id <== prescription_id;
    commitment.doctor_id <== doctor_id;
    commitment.medicine_code <== medicine_code;
    commitment.expiry <== expiry;
    commitment.threshold <== threshold;
    commitment_out <== commitment.commitment;

    // Identity Binding
    component identity = IdentityBinding();
    identity.patient_secret <== patient_secret;
    identity_ref_out <== identity.identity_ref;

    // Nullifier
    component nullifier = Nullifier();
    nullifier.patient_secret <== patient_secret;
    nullifier.commitment <== commitment.commitment;
    nullifier.slot_index <== slot_index;
    nullifier_out <== nullifier.nullifier;

    // Threshold Check
    component threshold_check = ThresholdCheck();
    threshold_check.slot_index <== slot_index;
    threshold_check.threshold <== threshold;

    threshold_check.valid === 1;

    // Selective Disclosure 
    component disclosure = SelectiveDisclosure();

    disclosure.medicine_code <== medicine_code;
    disclosure.disclosed_medicine_code <== disclosed_medicine_code;

    disclosure.valid === 1;
    // -------------------
// Doctor Registry
// -------------------

component registry = DoctorRegistry();

registry.doctor_leaf <== doctor_leaf;
registry.sibling0 <== sibling0;
registry.sibling1 <== sibling1;

registry.direction0 <== direction0;
registry.direction1 <== direction1;

registry.root <== root;

registry.valid === 1;

// -------------------
// Expiry Check
// -------------------

component expiry_check = LessEqThan(32);

expiry_check.in[0] <== current_date;
expiry_check.in[1] <== expiry;

expiry_check.out === 1;



// -------------------
// Schnorr Verification
// -------------------

component sig = SchnorrBJJ();

sig.Rx <== Rx;
sig.Ry <== Ry;

sig.PKx <== PKx;
sig.PKy <== PKy;

sig.C <== commitment.commitment;

sig.s <== s;

sig.valid === 1;

}

component main = EPrescriptionMain();
