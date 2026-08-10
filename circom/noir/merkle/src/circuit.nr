/// Constrained ordering helper for Merkle verification.
///
/// dir = 0 -> [current, sibling]
/// dir = 1 -> [sibling, current]
pub fn dual_mux(
    current: Field,
    sibling: Field,
    dir: u8,
) -> [Field; 2] {
    let d = dir as Field;

    let left = current * (1 - d) + sibling * d;
    let right = sibling * (1 - d) + current * d;

    [left, right]
}
