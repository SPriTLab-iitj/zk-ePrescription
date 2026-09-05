pragma circom 2.1.6;

include "../../lib/poseidon2/poseidon2_registry_leaf.circom";

template Main() {
    signal input doctor_id;
    signal input pubkey_x;
    signal input pubkey_y;
    signal input expected;

    component r = Poseidon2RegistryLeaf();

    r.doctor_id <== doctor_id;
    r.pubkey_x <== pubkey_x;
    r.pubkey_y <== pubkey_y;

    expected === r.leaf;
}

component main {
    public [
        doctor_id,
        pubkey_x,
        pubkey_y,
        expected
    ]
} = Main();
