use merkle::{MerklePath, verify_path};

fn main(leaf: Field, path: MerklePath<2>, root: pub Field) {
    assert(verify_path::<2>(leaf, path, root));
}
