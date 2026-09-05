mod poseidon2_hash;
mod tree_builder;
mod auth_path;

use tree_builder::build_tree;
use auth_path::authentication_path;

fn main(
    doctor_index: u32,
) -> pub [Field; 10] {

    // Canonical 16-doctor development registry.
    //
    // Doctor 5001 uses the valid BabyJubJub public key used by
    // the Phase4 Schnorr test vector so registry membership and
    // signature verification refer to the same key.

    let doctor_ids: [Field; 16] = [
        5001, 5002, 5003, 5004,
        5005, 5006, 5007, 5008,
        5009, 5010, 5011, 5012,
        5013, 5014, 5015, 5016
    ];

    let doctor_pubkey_xs: [Field; 16] = [
        0x16b051f37589e0dcf4ad3c415c090798c10d3095bedeedabfcc709ad787f3507,
        3333,
        5555,
        7777,
        9999,
        10019,
        10039,
        10059,
        10079,
        10099,
        10119,
        10139,
        10159,
        10179,
        10199,
        10219
    ];

    let doctor_pubkey_ys: [Field; 16] = [
        0x62800ac9e60839fab9218e5ed9d541f4586e41275f4071816a975895d349a5e,
        4444,
        6666,
        8888,
        10009,
        10029,
        10049,
        10069,
        10089,
        10109,
        10129,
        10149,
        10169,
        10189,
        10209,
        10229
    ];

    let tree = build_tree(
        doctor_ids,
        doctor_pubkey_xs,
        doctor_pubkey_ys,
    );

    authentication_path(
        doctor_index,
        tree,
    )
}
