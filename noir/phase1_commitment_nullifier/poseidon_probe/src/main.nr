mod poseidon2_hash;

use poseidon2_hash::{commitment_hash, identity_hash, nullifier_hash};

fn main() {}

#[test]
fn smoke_test_wrappers() {
    let inputs: [Field; 3] = [1, 2, 3];
    let c = commitment_hash(inputs);
    let i = identity_hash(inputs);
    let n = nullifier_hash(inputs);

    assert(c != i);
    assert(c != n);
    assert(i != n);
}
