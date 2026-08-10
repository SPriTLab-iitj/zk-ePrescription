pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/poseidon.circom";
include "../node_modules/circomlib/circuits/eddsaposeidon.circom";

template DoctorVerifier(depth) {
    // Inputs for identity and signature
    signal input doctorId;
    signal input doctorPkX;
    signal input doctorPkY;
    
    // Merkle tree proof inputs
    signal input merklePathElements[depth];
    signal input merklePathIndices[depth];
    signal input merkleRoot;

    // Doctor signature inputs
    signal input sigR8x;
    signal input sigR8y;
    signal input sigS;
    signal input commitment;

    // 1. Hash Doctor ID and Public Key to get Leaf
    component leafHasher = Poseidon(3);
    leafHasher.inputs[0] <== doctorId;
    leafHasher.inputs[1] <== doctorPkX;
    leafHasher.inputs[2] <== doctorPkY;

    signal leaf <== leafHasher.out;

    // 2. Validate Merkle membership path up to merkleRoot
    component hashers[depth];
    signal currentHash[depth + 1];
    currentHash[0] <== leaf;

    for (var i = 0; i < depth; i++) {
        hashers[i] = Poseidon(2);
        
        // If index is 0: hash(currentHash, pathElement)
        // If index is 1: hash(pathElement, currentHash)
        hashers[i].inputs[0] <== currentHash[i] + merklePathIndices[i] * (merklePathElements[i] - currentHash[i]);
        hashers[i].inputs[1] <== merklePathElements[i] + merklePathIndices[i] * (currentHash[i] - merklePathElements[i]);
        
        currentHash[i + 1] <== hashers[i].out;
    }

    // Enforce that computed root equals the public registry root
    currentHash[depth] === merkleRoot;

    // 3. Verify Doctor's Signature over the Commitment C
    component sigVerifier = EdDSAPoseidonVerifier();
    sigVerifier.enabled <== 1;
    sigVerifier.Ax <== doctorPkX;
    sigVerifier.Ay <== doctorPkY;
    sigVerifier.R8x <== sigR8x;
    sigVerifier.R8y <== sigR8y;
    sigVerifier.S <== sigS;
    sigVerifier.M <== commitment;
}
