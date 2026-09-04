use common::poseidon2_hash::commitment_hash;

/// Computes the prescription commitment.
///
/// Thin wrapper around the shared cryptographic
pub fn compute_commitment(
    prescription_id: Field,
    doctor_id: Field,
    medicine_code: Field,
    expiry_date: u64,
    quantity_threshold: u64,
) -> Field {

    commitment_hash([
        prescription_id,
        doctor_id,
        medicine_code,
        expiry_date as Field,
        quantity_threshold as Field,
    ])
}
