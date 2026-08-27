pragma circom 2.1.6;

include "lib_modules.circom";

template PatientBindingIssuance() {
    signal input patient_secret;
    signal input commitment;

    signal output patient_binding;
    signal output patient_prescription_binding;

    // Patient binding:
    //
    // B_P = Poseidon(patient_secret)
    //
    // This follows the existing Circom identity-binding construction.

    component identity = IdentityBinding();

    identity.patient_secret <== patient_secret;

    patient_binding <== identity.identity_ref;

    // Patient-prescription binding:
    //
    // PB = Poseidon(
    //     DOMAIN_PATIENT_BINDING,
    //     B_P,
    //     C
    // )
    //
    // DOMAIN_PATIENT_BINDING = 6
    //
    // The existing prescription commitment C remains unchanged.

    component binding_hash = Poseidon(3);

    binding_hash.inputs[0] <== 6;
    binding_hash.inputs[1] <== patient_binding;
    binding_hash.inputs[2] <== commitment;

    patient_prescription_binding <== binding_hash.out;
}

component main = PatientBindingIssuance();
