use merkle::{MerklePath, verify_path};

fn main(leaf: Field, path: MerklePath<3>, root: pub Field) {
    assert(verify_path::<3>(leaf, path, root));
}
