pragma circom 2.1.6;

include "../../lib/poseidon2/poseidon2_merkle.circom";

template Main() {
    signal input left;
    signal input right;
    signal input expected;

    component m = Poseidon2MerkleNode();

    m.left <== left;
    m.right <== right;

    expected === m.node;
}

component main {
    public [
        left,
        right,
        expected
    ]
} = Main();
