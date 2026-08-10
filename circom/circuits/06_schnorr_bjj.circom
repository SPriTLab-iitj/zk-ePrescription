pragma circom 2.1.6;

include "../node_modules/circomlib/circuits/poseidon.circom";
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

    // Challenge hash: e = Poseidon(Rx, Ry, PKx, PKy, C)
    component h = Poseidon(5);
    h.inputs[0] <== Rx;
    h.inputs[1] <== Ry;
    h.inputs[2] <== PKx;
    h.inputs[3] <== PKy;
    h.inputs[4] <== C;

    signal e;
    e <== h.out;

    // Decompose scalars into bits
    component eBits = Num2Bits(253);
    eBits.in <== e;

    component sBits = Num2Bits(253);
    sBits.in <== s;

    // BabyJubJub subgroup generator used by circomlib's BabyPbk
    var BASE8[2] = [
        5299619240641551281634865583518297030282874472190772894086521144482721001553,
        16950150798460657717958625567821834550301663161624707787222815936182638968203
    ];

    // sG
    component sG = EscalarMulFix(253, BASE8);
    // ePK
    component ePK = EscalarMulAny(253);

    for (var i = 0; i < 253; i++) {
        sG.e[i] <== sBits.out[i];
        ePK.e[i] <== eBits.out[i];
    }

    ePK.p[0] <== PKx;
    ePK.p[1] <== PKy;

    // R + ePK
    component rhs = BabyAdd();
    rhs.x1 <== Rx;
    rhs.y1 <== Ry;
    rhs.x2 <== ePK.out[0];
    rhs.y2 <== ePK.out[1];

    // Schnorr equation: sG == R + ePK
    sG.out[0] === rhs.xout;
    sG.out[1] === rhs.yout;

    valid <== 1;
}

// component main = SchnorrBJJ();
