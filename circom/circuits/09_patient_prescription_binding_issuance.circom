pragma circom 2.1.6;

include "lib_modules.circom";
include "../lib/poseidon2/poseidon2_patient_binding.circom";

template PatientBindingIssuance() {
    signal input patient_secret;
    signal input commitment;

    signal output patient_binding;
    signal output patient_prescription_binding;

    component identity = IdentityBinding();

    identity.patient_secret <== patient_secret;

    patient_binding <== identity.identity_ref;

    component binding_hash = Poseidon2PatientBinding();

    binding_hash.identity_ref <== patient_binding;
    binding_hash.commitment <== commitment;

    patient_prescription_binding <== binding_hash.patient_binding;
}

component main = PatientBindingIssuance();
