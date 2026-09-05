pragma circom 2.1.6;

include "../../lib/poseidon2/poseidon2_schnorr_challenge.circom";

template Main() {
    signal input Rx;
    signal input Ry;
    signal input PKx;
    signal input PKy;
    signal input commitment;
    signal input expected;

    component c = Poseidon2SchnorrChallenge();

    c.Rx <== Rx;
    c.Ry <== Ry;
    c.PKx <== PKx;
    c.PKy <== PKy;
    c.commitment <== commitment;

    expected === c.challenge;
}

component main {
    public [
        Rx,
        Ry,
        PKx,
        PKy,
        commitment,
        expected
    ]
} = Main();
