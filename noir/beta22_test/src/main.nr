use common::poseidon2_hash::{commitment_hash, poseidon2_hash_raw};

fn main(
    prescription_id: Field,
    doctor_id: Field,
    medicine_code: Field,
    doctor_pubkey_x: Field,
    doctor_pubkey_y: Field,
    signature_nonce_x: Field,
    signature_nonce_y: Field,
) -> pub [Field; 2] {
    let commitment = commitment_hash([prescription_id, doctor_id, medicine_code]);

    let challenge = poseidon2_hash_raw([
        signature_nonce_x,
        signature_nonce_y,
        doctor_pubkey_x,
        doctor_pubkey_y,
        commitment,
    ]);

    [commitment, challenge]
}
