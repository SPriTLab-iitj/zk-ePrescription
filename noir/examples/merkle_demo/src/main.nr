use merkle::{build_tree, extract_auth_path, verify_path};

/// Reference-only demo.
/// Runs unconstrained.
/// Used only for generating reference vectors.
unconstrained fn main() {

    let leaves = [
        1, 2, 3, 4,
        5, 6, 7, 8,
        9,10,11,12,
        13,14,15,16
    ];

    let tree = build_tree::<16>(leaves);

    // TV-008 : Rightmost leaf
    let (path, root) = extract_auth_path::<16, 4>(tree, 15);

    println(root);
    println(path.hashes);
    println(path.dirs);

    let ok = verify_path::<4>(16, path, root);

    let mut bad_path = path;
    bad_path.hashes[0] += 1;

    let bad = verify_path::<4>(16, bad_path, root);

    assert(ok);
    assert(!bad);
}
