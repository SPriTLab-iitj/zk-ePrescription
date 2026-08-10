pragma circom 2.1.6;

include "../node_modules/circomlib/circuits/poseidon.circom";

template DoctorRegistry(DEPTH) {
    signal input doctor_leaf;
    signal input pathElements[DEPTH];
    signal input pathIndices[DEPTH];
    signal input root;

    signal output valid;

    signal currentHash[DEPTH + 1];
    signal left[DEPTH];
    signal right[DEPTH];
    signal leftA[DEPTH];
    signal leftB[DEPTH];
    signal rightA[DEPTH];
    signal rightB[DEPTH];

    component hash[DEPTH];

    currentHash[0] <== doctor_leaf;

    for (var i = 0; i < DEPTH; i++) {
        pathIndices[i] * (pathIndices[i] - 1) === 0;

        leftA[i] <== currentHash[i] * (1 - pathIndices[i]);
        leftB[i] <== pathElements[i] * pathIndices[i];
        left[i] <== leftA[i] + leftB[i];

        rightA[i] <== currentHash[i] * pathIndices[i];
        rightB[i] <== pathElements[i] * (1 - pathIndices[i]);
        right[i] <== rightA[i] + rightB[i];

        hash[i] = Poseidon(2);
        hash[i].inputs[0] <== left[i];
        hash[i].inputs[1] <== right[i];

        currentHash[i + 1] <== hash[i].out;
    }

    currentHash[DEPTH] === root;
    valid <== 1;
}

component main {public [root]} = DoctorRegistry(4);
