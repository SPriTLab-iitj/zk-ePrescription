use merkle::{MerklePath, verify_path};

fn main(leaf: Field, path: MerklePath<4>, root: pub Field) {
    assert(verify_path::<4>(leaf, path, root));
}
