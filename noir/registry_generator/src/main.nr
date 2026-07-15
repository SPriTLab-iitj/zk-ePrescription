mod tree_builder;
mod auth_path;

use tree_builder::build_tree;
use auth_path::extract_auth_path;

fn main(
    doctor1_id: Field,
    doctor1_pubkey_x: Field,
    doctor1_pubkey_y: Field,

    doctor2_id: Field,
    doctor2_pubkey_x: Field,
    doctor2_pubkey_y: Field,

    doctor3_id: Field,
    doctor3_pubkey_x: Field,
    doctor3_pubkey_y: Field,

    doctor4_id: Field,
    doctor4_pubkey_x: Field,
    doctor4_pubkey_y: Field,

    doctor_index: u32,
) -> pub [Field; 8] {
    let tree = build_tree(
        doctor1_id,
        doctor1_pubkey_x,
        doctor1_pubkey_y,

        doctor2_id,
        doctor2_pubkey_x,
        doctor2_pubkey_y,

        doctor3_id,
        doctor3_pubkey_x,
        doctor3_pubkey_y,

        doctor4_id,
        doctor4_pubkey_x,
        doctor4_pubkey_y,
    );

    let auth_path = extract_auth_path(tree, doctor_index);

    let selected_doctor_id = if doctor_index == 0 {
        doctor1_id
    } else if doctor_index == 1 {
        doctor2_id
    } else if doctor_index == 2 {
        doctor3_id
    } else {
        doctor4_id
    };

    let selected_doctor_pubkey_x = if doctor_index == 0 {
        doctor1_pubkey_x
    } else if doctor_index == 1 {
        doctor2_pubkey_x
    } else if doctor_index == 2 {
        doctor3_pubkey_x
    } else {
        doctor4_pubkey_x
    };

    let selected_doctor_pubkey_y = if doctor_index == 0 {
        doctor1_pubkey_y
    } else if doctor_index == 1 {
        doctor2_pubkey_y
    } else if doctor_index == 2 {
        doctor3_pubkey_y
    } else {
        doctor4_pubkey_y
    };

    [
        auth_path[0],                 // registry_root
        selected_doctor_id,
        selected_doctor_pubkey_x,
        selected_doctor_pubkey_y,
        auth_path[1],                 // sibling0
        auth_path[2],                 // sibling1
        auth_path[3],                 // direction0
        auth_path[4],                 // direction1
    ]
}
