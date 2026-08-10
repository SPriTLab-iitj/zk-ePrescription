fn main(
    quantity_threshold: u64,
    slot_index: u64,
    expiry_date: u64,
    current_date: u64,
) -> pub [bool; 2] {

    let quantity_valid = slot_index < quantity_threshold;

    let expiry_valid = current_date <= expiry_date;

    [quantity_valid, expiry_valid]
}
// -----------------------------------------------------------------------
// Unit Tests
// -----------------------------------------------------------------------

mod tests {
    use super::main;

    // ------------------------------------------------------------
    // Test 1
    // Valid quantity
    // ------------------------------------------------------------

    #[test]
    fn valid_quantity() {
        let result = main(5, 2, 20260730, 20260729);
        assert(result[0] == true);
    }

    // ------------------------------------------------------------
    // Test 2
    // Quantity equals threshold
    // ------------------------------------------------------------

    #[test]
    fn quantity_equals_threshold() {
        let result = main(5, 5, 20260730, 20260729);
        assert(result[0] == false);
    }

    // ------------------------------------------------------------
    // Test 3
    // Expired prescription
    // ------------------------------------------------------------

    #[test]
    fn expired_prescription() {
        let result = main(5, 2, 20260730, 20260731);
        assert(result[1] == false);
    }

    // ------------------------------------------------------------
    // Test 4
    // Valid expiry
    // ------------------------------------------------------------

    #[test]
    fn valid_expiry() {
        let result = main(5, 2, 20260730, 20260729);
        assert(result[1] == true);
    }

    // ------------------------------------------------------------
    // Test 5
    // Both policies valid
    // ------------------------------------------------------------

    #[test]
    fn both_policies_valid() {
        let result = main(5, 2, 20260730, 20260729);

        assert(result[0] == true);
        assert(result[1] == true);
    }

    // ------------------------------------------------------------
    // Test 6
    // Both policies invalid
    // ------------------------------------------------------------

    #[test]
    fn both_policies_invalid() {
        let result = main(3, 3, 20260730, 20260731);

        assert(result[0] == false);
        assert(result[1] == false);
    }
}
