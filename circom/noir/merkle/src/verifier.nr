use crate::circuit::dual_mux;
use crate::hash::hash_node;
use crate::types::MerklePath;

/// Verify a Merkle membership proof.
///
/// SECURITY NOTE:
/// This function only verifies consistency with the supplied root.
/// It does NOT guarantee that the supplied root is the latest
/// published registry root.
///
/// The caller MUST obtain the current root from an authoritative
/// registry before trusting the result.
pub fn verify_path<let PATH_LEN: u32>(
    leaf: Field,
    path: MerklePath<PATH_LEN>,
    expected_root: Field,
) -> bool {
    let mut current = leaf;

    for i in 0..PATH_LEN {
        let ordered = dual_mux(
            current,
            path.hashes[i],
            path.dirs[i],
        );

        current = hash_node(
            ordered[0],
            ordered[1],
        );
    }

    current == expected_root
}
