pragma circom 2.1.6;

include "lib_modules.circom";

template IdentityBindingCircuit() {
    signal input patient_secret;
    signal output identity_ref;

    component i = IdentityBinding();

    i.patient_secret <== patient_secret;

    identity_ref <== i.identity_ref;
}

component main = IdentityBindingCircuit();
