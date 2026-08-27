/// Verifies that the disclosed medicine code matches the medicine code
/// contained in the private prescription witness.
///
/// The current prototype exposes only the medicine code as a disclosed
/// prescription attribute. Other prescription fields remain private.
pub fn verify_disclosure(
    medicine_code: Field,
    disclosed_medicine_code: Field,
) -> bool {
    medicine_code == disclosed_medicine_code
}

#[test]
fn valid_disclosure_is_accepted() {
    assert(verify_disclosure(123, 123));
}

#[test]
fn invalid_disclosure_is_rejected() {
    assert(!verify_disclosure(123, 124));
}

#[test]
fn disclosure_is_sensitive_to_the_disclosed_value() {
    let medicine_code = 123;

    assert(verify_disclosure(medicine_code, 123));
    assert(!verify_disclosure(medicine_code, 999));
}
