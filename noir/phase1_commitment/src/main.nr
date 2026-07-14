use common::poseidon2_hash::{
    commitment_hash,
    identity_hash,
    nullifier_hash,
};

fn main(
    prescription_id: Field,
    doctor_id: Field,
    medicine_code: Field,
    patient_secret: Field,
    slot_index: u32,
) -> pub [Field; 2] {

    // Internal identity reference (not publicly returned)
    let _identity_ref = identity_hash([
        patient_secret
    ]);

    // Prescription commitment
    let commitment = commitment_hash([
        prescription_id,
        doctor_id,
        medicine_code
    ]);

    // Replay-protection nullifier
    let nullifier = nullifier_hash([
        patient_secret,
        commitment,
        slot_index as Field
    ]);

    [commitment, nullifier]
}
