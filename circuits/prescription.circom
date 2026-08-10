pragma circom 2.0.0;

include "./commitment.circom";
include "./identity.circom";
include "./nullifier.circom";
include "./threshold.circom";
include "./disclosure.circom";
include "./doctor.circom";

template PrescriptionRedemption(merkleDepth) {
    // === PUBLIC INPUTS ===
    signal input commitment;
    signal input identityToken;
    signal input nullifier;
    signal input expiry;
    signal input threshold;
    signal input registryVersion;
    signal input merkleRoot;
    signal input redemptionIndex;
    signal input domainSeparator;
    
    // Selective Disclosure Public Signals
    signal input discloseMedicineCodeFlag;
    signal input discloseMedicineQtyFlag;
    signal input disclosedMedicineCode;
    signal input disclosedMedicineQty;

    // === PRIVATE INPUTS ===
    signal input patientSecret;
    signal input prescriptionId;
    signal input medicineCode;
    signal input medicineQty;
    
    signal input doctorId;
    signal input doctorPkX;
    signal input doctorPkY;
    
    signal input merklePathElements[merkleDepth];
    signal input merklePathIndices[merkleDepth];
    
    signal input sigR8x;
    signal input sigR8y;
    signal input sigS;

    // --- 1. Identity Binding ---
    component idBinder = IdentityBinder();
    idBinder.patientSecret <== patientSecret;
    idBinder.domainSeparator <== domainSeparator;
    idBinder.identityToken === identityToken;

    // --- 2. Commitment Verification ---
    component commitmentHasher = CommitmentHasher();
    commitmentHasher.prescriptionId <== prescriptionId;
    commitmentHasher.identityToken <== identityToken;
    commitmentHasher.medicineCode <== medicineCode;
    commitmentHasher.medicineQty <== medicineQty;
    commitmentHasher.expiry <== expiry;
    commitmentHasher.threshold <== threshold;
    commitmentHasher.registryVersion <== registryVersion;
    commitmentHasher.commitment === commitment;

    // --- 3. Nullifier Generation ---
    component nullifierDeriver = NullifierDeriver();
    nullifierDeriver.patientSecret <== patientSecret;
    nullifierDeriver.commitment <== commitment;
    nullifierDeriver.redemptionIndex <== redemptionIndex;
    nullifierDeriver.domainSeparator <== domainSeparator;
    nullifierDeriver.nullifier === nullifier;

    // --- 4. Threshold Enforcement ---
    component thresholdEnforcer = ThresholdEnforcer();
    thresholdEnforcer.redemptionIndex <== redemptionIndex;
    thresholdEnforcer.threshold <== threshold;

    // --- 5. Doctor Registry & Signature Verification ---
    component doctorVerifier = DoctorVerifier(merkleDepth);
    doctorVerifier.doctorId <== doctorId;
    doctorVerifier.doctorPkX <== doctorPkX;
    doctorVerifier.doctorPkY <== doctorPkY;
    doctorVerifier.merkleRoot <== merkleRoot;
    doctorVerifier.sigR8x <== sigR8x;
    doctorVerifier.sigR8y <== sigR8y;
    doctorVerifier.sigS <== sigS;
    doctorVerifier.commitment <== commitment;
    for (var i = 0; i < merkleDepth; i++) {
        doctorVerifier.merklePathElements[i] <== merklePathElements[i];
        doctorVerifier.merklePathIndices[i] <== merklePathIndices[i];
    }

    // --- 6. Selective Disclosure ---
    component codeDiscloser = SelectiveDiscloser();
    codeDiscloser.field <== medicineCode;
    codeDiscloser.discloseFlag <== discloseMedicineCodeFlag;
    codeDiscloser.disclosedField === disclosedMedicineCode;

    component qtyDiscloser = SelectiveDiscloser();
    qtyDiscloser.field <== medicineQty;
    qtyDiscloser.discloseFlag <== discloseMedicineQtyFlag;
    qtyDiscloser.disclosedField === disclosedMedicineQty;
}

// Instantiate with a doctor registry Merkle depth of 10 (supports up to 1024 doctors)
component main {public [
    commitment,
    identityToken,
    nullifier,
    expiry,
    threshold,
    registryVersion,
    merkleRoot,
    redemptionIndex,
    domainSeparator,
    discloseMedicineCodeFlag,
    discloseMedicineQtyFlag,
    disclosedMedicineCode,
    disclosedMedicineQty
]} = PrescriptionRedemption(10);
