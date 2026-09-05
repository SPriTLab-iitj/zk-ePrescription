pragma circom 2.1.6;

include "../lib/poseidon2/poseidon2_schnorr_challenge.circom";
include "../node_modules/circomlib/circuits/babyjub.circom";
include "../node_modules/circomlib/circuits/escalarmulany.circom";

template SchnorrBJJ() {
    // Public inputs for verification
    signal input Rx;
    signal input Ry;
    signal input PKx;
    signal input PKy;
    signal input C;
    signal input s;

    signal output valid;

    // Check that R and PK are valid BabyJubJub points
    component checkR = BabyCheck();
    checkR.x <== Rx;
    checkR.y <== Ry;

    component checkPK = BabyCheck();
    checkPK.x <== PKx;
    checkPK.y <== PKy;

    // Challenge hash: e = Poseidon2_raw(Rx, Ry, PKx, PKy, C)
    component h = Poseidon2SchnorrChallenge();
    h.Rx <== Rx;
    h.Ry <== Ry;
    h.PKx <== PKx;
    h.PKy <== PKy;
    h.commitment <== C;

    signal e;
    e <== h.challenge;

    // Decompose scalars into bits
    // e is a raw Poseidon2 BN254 field element and may occupy up to 254 bits.
    component eBits = Num2Bits(254);
    eBits.in <== e;

    component sBits = Num2Bits(253);
    sBits.in <== s;

    // BabyJubJub subgroup generator used by circomlib's BabyPbk
    var BASE8[2] = [
        5299619240641551281634865583518297030282874472190772894086521144482721001553,
        16950150798460657717958625567821834550301663161624707787222815936182638968203
    ];

    // sG: s is a BabyJubJub subgroup scalar < 2^253, so 253 bits suffices.
    component sG = EscalarMulFix(253, BASE8);

    // Cofactor-clear the public key to match the Noir verifier:
    // PK8 = 8 * PK, implemented as three point doublings.
    component pk2 = BabyAdd();
    pk2.x1 <== PKx;
    pk2.y1 <== PKy;
    pk2.x2 <== PKx;
    pk2.y2 <== PKy;

    component pk4 = BabyAdd();
    pk4.x1 <== pk2.xout;
    pk4.y1 <== pk2.yout;
    pk4.x2 <== pk2.xout;
    pk4.y2 <== pk2.yout;

    component pk8 = BabyAdd();
    pk8.x1 <== pk4.xout;
    pk8.y1 <== pk4.yout;
    pk8.x2 <== pk4.xout;
    pk8.y2 <== pk4.yout;

    // ePK: e may be up to 254 bits, so use 254.
    component ePK = EscalarMulAny(254);

    for (var i = 0; i < 253; i++) {
        sG.e[i] <== sBits.out[i];
    }
    for (var i = 0; i < 254; i++) {
        ePK.e[i] <== eBits.out[i];
    }

    // Multiply the cofactor-cleared public key by the challenge.
    ePK.p[0] <== pk8.xout;
    ePK.p[1] <== pk8.yout;

    // R + ePK
    component rhs = BabyAdd();
    rhs.x1 <== Rx;
    rhs.y1 <== Ry;
    rhs.x2 <== ePK.out[0];
    rhs.y2 <== ePK.out[1];

    // Schnorr equation: sG == R + e * (8 * PK)
    sG.out[0] === rhs.xout;
    sG.out[1] === rhs.yout;

    valid <== 1;
}

// component main = SchnorrBJJ();
