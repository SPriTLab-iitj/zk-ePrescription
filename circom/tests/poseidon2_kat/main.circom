pragma circom 2.1.6;

include "../../lib/poseidon2/poseidon2_permutation.circom";

template Main() {
    signal input in0;
    signal input in1;
    signal input in2;
    signal input in3;

    signal input expected0;
    signal input expected1;
    signal input expected2;
    signal input expected3;

    component p = Poseidon2Permutation();

    p.state_in[0] <== in0;
    p.state_in[1] <== in1;
    p.state_in[2] <== in2;
    p.state_in[3] <== in3;

    expected0 === p.state_out[0];
    expected1 === p.state_out[1];
    expected2 === p.state_out[2];
    expected3 === p.state_out[3];
}

component main {public [in0, in1, in2, in3, expected0, expected1, expected2, expected3]} = Main();
