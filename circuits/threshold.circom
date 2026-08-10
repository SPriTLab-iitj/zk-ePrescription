pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/comparators.circom";

template ThresholdEnforcer() {
    signal input redemptionIndex;
    signal input threshold;

    // Enforce 0 <= redemptionIndex < threshold
    // Using LessThan(64) since index/threshold fit in 64 bits.
    component lt = LessThan(64);
    lt.in[0] <== redemptionIndex;
    lt.in[1] <== threshold;
    
    lt.out === 1;
}
