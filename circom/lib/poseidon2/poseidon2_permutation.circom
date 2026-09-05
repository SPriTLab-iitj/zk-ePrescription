pragma circom 2.1.6;

include "poseidon2_constants.circom";

// Poseidon2 permutation matching Noir 1.0.0-beta.24
// Noir commit: 5021a7196dc49d8e515177624f8759568f3360c0
// BN254 | t=4 | RF=8 | RP=56 | S-box x^5

template Poseidon2Permutation() {
    signal input state_in[4];
    signal output state_out[4];
    signal state[65][4];

    // Initial external linear layer
    state[0][0] <== 5*state_in[0] + 7*state_in[1] + state_in[2] + 3*state_in[3];
    state[0][1] <== 4*state_in[0] + 6*state_in[1] + state_in[2] + state_in[3];
    state[0][2] <== state_in[0] + 3*state_in[1] + 5*state_in[2] + 7*state_in[3];
    state[0][3] <== state_in[0] + state_in[1] + 4*state_in[2] + 6*state_in[3];

    // External full round 0
    signal full_0_0;
    full_0_0 <== state[0][0] + poseidon2_rc(0, 0);
    signal ext_0_0_x2;
    ext_0_0_x2 <== full_0_0*full_0_0;
    signal ext_0_0_x4;
    ext_0_0_x4 <== ext_0_0_x2*ext_0_0_x2;
    signal ext_0_0_x5;
    ext_0_0_x5 <== ext_0_0_x4*full_0_0;
    signal full_0_1;
    full_0_1 <== state[0][1] + poseidon2_rc(0, 1);
    signal ext_0_1_x2;
    ext_0_1_x2 <== full_0_1*full_0_1;
    signal ext_0_1_x4;
    ext_0_1_x4 <== ext_0_1_x2*ext_0_1_x2;
    signal ext_0_1_x5;
    ext_0_1_x5 <== ext_0_1_x4*full_0_1;
    signal full_0_2;
    full_0_2 <== state[0][2] + poseidon2_rc(0, 2);
    signal ext_0_2_x2;
    ext_0_2_x2 <== full_0_2*full_0_2;
    signal ext_0_2_x4;
    ext_0_2_x4 <== ext_0_2_x2*ext_0_2_x2;
    signal ext_0_2_x5;
    ext_0_2_x5 <== ext_0_2_x4*full_0_2;
    signal full_0_3;
    full_0_3 <== state[0][3] + poseidon2_rc(0, 3);
    signal ext_0_3_x2;
    ext_0_3_x2 <== full_0_3*full_0_3;
    signal ext_0_3_x4;
    ext_0_3_x4 <== ext_0_3_x2*ext_0_3_x2;
    signal ext_0_3_x5;
    ext_0_3_x5 <== ext_0_3_x4*full_0_3;
    state[1][0] <== 5*ext_0_0_x5 + 7*ext_0_1_x5 + ext_0_2_x5 + 3*ext_0_3_x5;
    state[1][1] <== 4*ext_0_0_x5 + 6*ext_0_1_x5 + ext_0_2_x5 + ext_0_3_x5;
    state[1][2] <== ext_0_0_x5 + 3*ext_0_1_x5 + 5*ext_0_2_x5 + 7*ext_0_3_x5;
    state[1][3] <== ext_0_0_x5 + ext_0_1_x5 + 4*ext_0_2_x5 + 6*ext_0_3_x5;

    // External full round 1
    signal full_1_0;
    full_1_0 <== state[1][0] + poseidon2_rc(1, 0);
    signal ext_1_0_x2;
    ext_1_0_x2 <== full_1_0*full_1_0;
    signal ext_1_0_x4;
    ext_1_0_x4 <== ext_1_0_x2*ext_1_0_x2;
    signal ext_1_0_x5;
    ext_1_0_x5 <== ext_1_0_x4*full_1_0;
    signal full_1_1;
    full_1_1 <== state[1][1] + poseidon2_rc(1, 1);
    signal ext_1_1_x2;
    ext_1_1_x2 <== full_1_1*full_1_1;
    signal ext_1_1_x4;
    ext_1_1_x4 <== ext_1_1_x2*ext_1_1_x2;
    signal ext_1_1_x5;
    ext_1_1_x5 <== ext_1_1_x4*full_1_1;
    signal full_1_2;
    full_1_2 <== state[1][2] + poseidon2_rc(1, 2);
    signal ext_1_2_x2;
    ext_1_2_x2 <== full_1_2*full_1_2;
    signal ext_1_2_x4;
    ext_1_2_x4 <== ext_1_2_x2*ext_1_2_x2;
    signal ext_1_2_x5;
    ext_1_2_x5 <== ext_1_2_x4*full_1_2;
    signal full_1_3;
    full_1_3 <== state[1][3] + poseidon2_rc(1, 3);
    signal ext_1_3_x2;
    ext_1_3_x2 <== full_1_3*full_1_3;
    signal ext_1_3_x4;
    ext_1_3_x4 <== ext_1_3_x2*ext_1_3_x2;
    signal ext_1_3_x5;
    ext_1_3_x5 <== ext_1_3_x4*full_1_3;
    state[2][0] <== 5*ext_1_0_x5 + 7*ext_1_1_x5 + ext_1_2_x5 + 3*ext_1_3_x5;
    state[2][1] <== 4*ext_1_0_x5 + 6*ext_1_1_x5 + ext_1_2_x5 + ext_1_3_x5;
    state[2][2] <== ext_1_0_x5 + 3*ext_1_1_x5 + 5*ext_1_2_x5 + 7*ext_1_3_x5;
    state[2][3] <== ext_1_0_x5 + ext_1_1_x5 + 4*ext_1_2_x5 + 6*ext_1_3_x5;

    // External full round 2
    signal full_2_0;
    full_2_0 <== state[2][0] + poseidon2_rc(2, 0);
    signal ext_2_0_x2;
    ext_2_0_x2 <== full_2_0*full_2_0;
    signal ext_2_0_x4;
    ext_2_0_x4 <== ext_2_0_x2*ext_2_0_x2;
    signal ext_2_0_x5;
    ext_2_0_x5 <== ext_2_0_x4*full_2_0;
    signal full_2_1;
    full_2_1 <== state[2][1] + poseidon2_rc(2, 1);
    signal ext_2_1_x2;
    ext_2_1_x2 <== full_2_1*full_2_1;
    signal ext_2_1_x4;
    ext_2_1_x4 <== ext_2_1_x2*ext_2_1_x2;
    signal ext_2_1_x5;
    ext_2_1_x5 <== ext_2_1_x4*full_2_1;
    signal full_2_2;
    full_2_2 <== state[2][2] + poseidon2_rc(2, 2);
    signal ext_2_2_x2;
    ext_2_2_x2 <== full_2_2*full_2_2;
    signal ext_2_2_x4;
    ext_2_2_x4 <== ext_2_2_x2*ext_2_2_x2;
    signal ext_2_2_x5;
    ext_2_2_x5 <== ext_2_2_x4*full_2_2;
    signal full_2_3;
    full_2_3 <== state[2][3] + poseidon2_rc(2, 3);
    signal ext_2_3_x2;
    ext_2_3_x2 <== full_2_3*full_2_3;
    signal ext_2_3_x4;
    ext_2_3_x4 <== ext_2_3_x2*ext_2_3_x2;
    signal ext_2_3_x5;
    ext_2_3_x5 <== ext_2_3_x4*full_2_3;
    state[3][0] <== 5*ext_2_0_x5 + 7*ext_2_1_x5 + ext_2_2_x5 + 3*ext_2_3_x5;
    state[3][1] <== 4*ext_2_0_x5 + 6*ext_2_1_x5 + ext_2_2_x5 + ext_2_3_x5;
    state[3][2] <== ext_2_0_x5 + 3*ext_2_1_x5 + 5*ext_2_2_x5 + 7*ext_2_3_x5;
    state[3][3] <== ext_2_0_x5 + ext_2_1_x5 + 4*ext_2_2_x5 + 6*ext_2_3_x5;

    // External full round 3
    signal full_3_0;
    full_3_0 <== state[3][0] + poseidon2_rc(3, 0);
    signal ext_3_0_x2;
    ext_3_0_x2 <== full_3_0*full_3_0;
    signal ext_3_0_x4;
    ext_3_0_x4 <== ext_3_0_x2*ext_3_0_x2;
    signal ext_3_0_x5;
    ext_3_0_x5 <== ext_3_0_x4*full_3_0;
    signal full_3_1;
    full_3_1 <== state[3][1] + poseidon2_rc(3, 1);
    signal ext_3_1_x2;
    ext_3_1_x2 <== full_3_1*full_3_1;
    signal ext_3_1_x4;
    ext_3_1_x4 <== ext_3_1_x2*ext_3_1_x2;
    signal ext_3_1_x5;
    ext_3_1_x5 <== ext_3_1_x4*full_3_1;
    signal full_3_2;
    full_3_2 <== state[3][2] + poseidon2_rc(3, 2);
    signal ext_3_2_x2;
    ext_3_2_x2 <== full_3_2*full_3_2;
    signal ext_3_2_x4;
    ext_3_2_x4 <== ext_3_2_x2*ext_3_2_x2;
    signal ext_3_2_x5;
    ext_3_2_x5 <== ext_3_2_x4*full_3_2;
    signal full_3_3;
    full_3_3 <== state[3][3] + poseidon2_rc(3, 3);
    signal ext_3_3_x2;
    ext_3_3_x2 <== full_3_3*full_3_3;
    signal ext_3_3_x4;
    ext_3_3_x4 <== ext_3_3_x2*ext_3_3_x2;
    signal ext_3_3_x5;
    ext_3_3_x5 <== ext_3_3_x4*full_3_3;
    state[4][0] <== 5*ext_3_0_x5 + 7*ext_3_1_x5 + ext_3_2_x5 + 3*ext_3_3_x5;
    state[4][1] <== 4*ext_3_0_x5 + 6*ext_3_1_x5 + ext_3_2_x5 + ext_3_3_x5;
    state[4][2] <== ext_3_0_x5 + 3*ext_3_1_x5 + 5*ext_3_2_x5 + 7*ext_3_3_x5;
    state[4][3] <== ext_3_0_x5 + ext_3_1_x5 + 4*ext_3_2_x5 + 6*ext_3_3_x5;

    // Internal round 0 (round 4)
    signal int_add_0;
    int_add_0 <== state[4][0] + poseidon2_rc(4, 0);
    signal int_0_x2;
    int_0_x2 <== int_add_0*int_add_0;
    signal int_0_x4;
    int_0_x4 <== int_0_x2*int_0_x2;
    signal int_0_x5;
    int_0_x5 <== int_0_x4*int_add_0;
    signal int_sum_0;
    int_sum_0 <== int_0_x5 + state[4][1] + state[4][2] + state[4][3];
    state[5][0] <== int_0_x5*poseidon2_internal_diag(0) + int_sum_0;
    state[5][1] <== state[4][1]*poseidon2_internal_diag(1) + int_sum_0;
    state[5][2] <== state[4][2]*poseidon2_internal_diag(2) + int_sum_0;
    state[5][3] <== state[4][3]*poseidon2_internal_diag(3) + int_sum_0;

    // Internal round 1 (round 5)
    signal int_add_1;
    int_add_1 <== state[5][0] + poseidon2_rc(5, 0);
    signal int_1_x2;
    int_1_x2 <== int_add_1*int_add_1;
    signal int_1_x4;
    int_1_x4 <== int_1_x2*int_1_x2;
    signal int_1_x5;
    int_1_x5 <== int_1_x4*int_add_1;
    signal int_sum_1;
    int_sum_1 <== int_1_x5 + state[5][1] + state[5][2] + state[5][3];
    state[6][0] <== int_1_x5*poseidon2_internal_diag(0) + int_sum_1;
    state[6][1] <== state[5][1]*poseidon2_internal_diag(1) + int_sum_1;
    state[6][2] <== state[5][2]*poseidon2_internal_diag(2) + int_sum_1;
    state[6][3] <== state[5][3]*poseidon2_internal_diag(3) + int_sum_1;

    // Internal round 2 (round 6)
    signal int_add_2;
    int_add_2 <== state[6][0] + poseidon2_rc(6, 0);
    signal int_2_x2;
    int_2_x2 <== int_add_2*int_add_2;
    signal int_2_x4;
    int_2_x4 <== int_2_x2*int_2_x2;
    signal int_2_x5;
    int_2_x5 <== int_2_x4*int_add_2;
    signal int_sum_2;
    int_sum_2 <== int_2_x5 + state[6][1] + state[6][2] + state[6][3];
    state[7][0] <== int_2_x5*poseidon2_internal_diag(0) + int_sum_2;
    state[7][1] <== state[6][1]*poseidon2_internal_diag(1) + int_sum_2;
    state[7][2] <== state[6][2]*poseidon2_internal_diag(2) + int_sum_2;
    state[7][3] <== state[6][3]*poseidon2_internal_diag(3) + int_sum_2;

    // Internal round 3 (round 7)
    signal int_add_3;
    int_add_3 <== state[7][0] + poseidon2_rc(7, 0);
    signal int_3_x2;
    int_3_x2 <== int_add_3*int_add_3;
    signal int_3_x4;
    int_3_x4 <== int_3_x2*int_3_x2;
    signal int_3_x5;
    int_3_x5 <== int_3_x4*int_add_3;
    signal int_sum_3;
    int_sum_3 <== int_3_x5 + state[7][1] + state[7][2] + state[7][3];
    state[8][0] <== int_3_x5*poseidon2_internal_diag(0) + int_sum_3;
    state[8][1] <== state[7][1]*poseidon2_internal_diag(1) + int_sum_3;
    state[8][2] <== state[7][2]*poseidon2_internal_diag(2) + int_sum_3;
    state[8][3] <== state[7][3]*poseidon2_internal_diag(3) + int_sum_3;

    // Internal round 4 (round 8)
    signal int_add_4;
    int_add_4 <== state[8][0] + poseidon2_rc(8, 0);
    signal int_4_x2;
    int_4_x2 <== int_add_4*int_add_4;
    signal int_4_x4;
    int_4_x4 <== int_4_x2*int_4_x2;
    signal int_4_x5;
    int_4_x5 <== int_4_x4*int_add_4;
    signal int_sum_4;
    int_sum_4 <== int_4_x5 + state[8][1] + state[8][2] + state[8][3];
    state[9][0] <== int_4_x5*poseidon2_internal_diag(0) + int_sum_4;
    state[9][1] <== state[8][1]*poseidon2_internal_diag(1) + int_sum_4;
    state[9][2] <== state[8][2]*poseidon2_internal_diag(2) + int_sum_4;
    state[9][3] <== state[8][3]*poseidon2_internal_diag(3) + int_sum_4;

    // Internal round 5 (round 9)
    signal int_add_5;
    int_add_5 <== state[9][0] + poseidon2_rc(9, 0);
    signal int_5_x2;
    int_5_x2 <== int_add_5*int_add_5;
    signal int_5_x4;
    int_5_x4 <== int_5_x2*int_5_x2;
    signal int_5_x5;
    int_5_x5 <== int_5_x4*int_add_5;
    signal int_sum_5;
    int_sum_5 <== int_5_x5 + state[9][1] + state[9][2] + state[9][3];
    state[10][0] <== int_5_x5*poseidon2_internal_diag(0) + int_sum_5;
    state[10][1] <== state[9][1]*poseidon2_internal_diag(1) + int_sum_5;
    state[10][2] <== state[9][2]*poseidon2_internal_diag(2) + int_sum_5;
    state[10][3] <== state[9][3]*poseidon2_internal_diag(3) + int_sum_5;

    // Internal round 6 (round 10)
    signal int_add_6;
    int_add_6 <== state[10][0] + poseidon2_rc(10, 0);
    signal int_6_x2;
    int_6_x2 <== int_add_6*int_add_6;
    signal int_6_x4;
    int_6_x4 <== int_6_x2*int_6_x2;
    signal int_6_x5;
    int_6_x5 <== int_6_x4*int_add_6;
    signal int_sum_6;
    int_sum_6 <== int_6_x5 + state[10][1] + state[10][2] + state[10][3];
    state[11][0] <== int_6_x5*poseidon2_internal_diag(0) + int_sum_6;
    state[11][1] <== state[10][1]*poseidon2_internal_diag(1) + int_sum_6;
    state[11][2] <== state[10][2]*poseidon2_internal_diag(2) + int_sum_6;
    state[11][3] <== state[10][3]*poseidon2_internal_diag(3) + int_sum_6;

    // Internal round 7 (round 11)
    signal int_add_7;
    int_add_7 <== state[11][0] + poseidon2_rc(11, 0);
    signal int_7_x2;
    int_7_x2 <== int_add_7*int_add_7;
    signal int_7_x4;
    int_7_x4 <== int_7_x2*int_7_x2;
    signal int_7_x5;
    int_7_x5 <== int_7_x4*int_add_7;
    signal int_sum_7;
    int_sum_7 <== int_7_x5 + state[11][1] + state[11][2] + state[11][3];
    state[12][0] <== int_7_x5*poseidon2_internal_diag(0) + int_sum_7;
    state[12][1] <== state[11][1]*poseidon2_internal_diag(1) + int_sum_7;
    state[12][2] <== state[11][2]*poseidon2_internal_diag(2) + int_sum_7;
    state[12][3] <== state[11][3]*poseidon2_internal_diag(3) + int_sum_7;

    // Internal round 8 (round 12)
    signal int_add_8;
    int_add_8 <== state[12][0] + poseidon2_rc(12, 0);
    signal int_8_x2;
    int_8_x2 <== int_add_8*int_add_8;
    signal int_8_x4;
    int_8_x4 <== int_8_x2*int_8_x2;
    signal int_8_x5;
    int_8_x5 <== int_8_x4*int_add_8;
    signal int_sum_8;
    int_sum_8 <== int_8_x5 + state[12][1] + state[12][2] + state[12][3];
    state[13][0] <== int_8_x5*poseidon2_internal_diag(0) + int_sum_8;
    state[13][1] <== state[12][1]*poseidon2_internal_diag(1) + int_sum_8;
    state[13][2] <== state[12][2]*poseidon2_internal_diag(2) + int_sum_8;
    state[13][3] <== state[12][3]*poseidon2_internal_diag(3) + int_sum_8;

    // Internal round 9 (round 13)
    signal int_add_9;
    int_add_9 <== state[13][0] + poseidon2_rc(13, 0);
    signal int_9_x2;
    int_9_x2 <== int_add_9*int_add_9;
    signal int_9_x4;
    int_9_x4 <== int_9_x2*int_9_x2;
    signal int_9_x5;
    int_9_x5 <== int_9_x4*int_add_9;
    signal int_sum_9;
    int_sum_9 <== int_9_x5 + state[13][1] + state[13][2] + state[13][3];
    state[14][0] <== int_9_x5*poseidon2_internal_diag(0) + int_sum_9;
    state[14][1] <== state[13][1]*poseidon2_internal_diag(1) + int_sum_9;
    state[14][2] <== state[13][2]*poseidon2_internal_diag(2) + int_sum_9;
    state[14][3] <== state[13][3]*poseidon2_internal_diag(3) + int_sum_9;

    // Internal round 10 (round 14)
    signal int_add_10;
    int_add_10 <== state[14][0] + poseidon2_rc(14, 0);
    signal int_10_x2;
    int_10_x2 <== int_add_10*int_add_10;
    signal int_10_x4;
    int_10_x4 <== int_10_x2*int_10_x2;
    signal int_10_x5;
    int_10_x5 <== int_10_x4*int_add_10;
    signal int_sum_10;
    int_sum_10 <== int_10_x5 + state[14][1] + state[14][2] + state[14][3];
    state[15][0] <== int_10_x5*poseidon2_internal_diag(0) + int_sum_10;
    state[15][1] <== state[14][1]*poseidon2_internal_diag(1) + int_sum_10;
    state[15][2] <== state[14][2]*poseidon2_internal_diag(2) + int_sum_10;
    state[15][3] <== state[14][3]*poseidon2_internal_diag(3) + int_sum_10;

    // Internal round 11 (round 15)
    signal int_add_11;
    int_add_11 <== state[15][0] + poseidon2_rc(15, 0);
    signal int_11_x2;
    int_11_x2 <== int_add_11*int_add_11;
    signal int_11_x4;
    int_11_x4 <== int_11_x2*int_11_x2;
    signal int_11_x5;
    int_11_x5 <== int_11_x4*int_add_11;
    signal int_sum_11;
    int_sum_11 <== int_11_x5 + state[15][1] + state[15][2] + state[15][3];
    state[16][0] <== int_11_x5*poseidon2_internal_diag(0) + int_sum_11;
    state[16][1] <== state[15][1]*poseidon2_internal_diag(1) + int_sum_11;
    state[16][2] <== state[15][2]*poseidon2_internal_diag(2) + int_sum_11;
    state[16][3] <== state[15][3]*poseidon2_internal_diag(3) + int_sum_11;

    // Internal round 12 (round 16)
    signal int_add_12;
    int_add_12 <== state[16][0] + poseidon2_rc(16, 0);
    signal int_12_x2;
    int_12_x2 <== int_add_12*int_add_12;
    signal int_12_x4;
    int_12_x4 <== int_12_x2*int_12_x2;
    signal int_12_x5;
    int_12_x5 <== int_12_x4*int_add_12;
    signal int_sum_12;
    int_sum_12 <== int_12_x5 + state[16][1] + state[16][2] + state[16][3];
    state[17][0] <== int_12_x5*poseidon2_internal_diag(0) + int_sum_12;
    state[17][1] <== state[16][1]*poseidon2_internal_diag(1) + int_sum_12;
    state[17][2] <== state[16][2]*poseidon2_internal_diag(2) + int_sum_12;
    state[17][3] <== state[16][3]*poseidon2_internal_diag(3) + int_sum_12;

    // Internal round 13 (round 17)
    signal int_add_13;
    int_add_13 <== state[17][0] + poseidon2_rc(17, 0);
    signal int_13_x2;
    int_13_x2 <== int_add_13*int_add_13;
    signal int_13_x4;
    int_13_x4 <== int_13_x2*int_13_x2;
    signal int_13_x5;
    int_13_x5 <== int_13_x4*int_add_13;
    signal int_sum_13;
    int_sum_13 <== int_13_x5 + state[17][1] + state[17][2] + state[17][3];
    state[18][0] <== int_13_x5*poseidon2_internal_diag(0) + int_sum_13;
    state[18][1] <== state[17][1]*poseidon2_internal_diag(1) + int_sum_13;
    state[18][2] <== state[17][2]*poseidon2_internal_diag(2) + int_sum_13;
    state[18][3] <== state[17][3]*poseidon2_internal_diag(3) + int_sum_13;

    // Internal round 14 (round 18)
    signal int_add_14;
    int_add_14 <== state[18][0] + poseidon2_rc(18, 0);
    signal int_14_x2;
    int_14_x2 <== int_add_14*int_add_14;
    signal int_14_x4;
    int_14_x4 <== int_14_x2*int_14_x2;
    signal int_14_x5;
    int_14_x5 <== int_14_x4*int_add_14;
    signal int_sum_14;
    int_sum_14 <== int_14_x5 + state[18][1] + state[18][2] + state[18][3];
    state[19][0] <== int_14_x5*poseidon2_internal_diag(0) + int_sum_14;
    state[19][1] <== state[18][1]*poseidon2_internal_diag(1) + int_sum_14;
    state[19][2] <== state[18][2]*poseidon2_internal_diag(2) + int_sum_14;
    state[19][3] <== state[18][3]*poseidon2_internal_diag(3) + int_sum_14;

    // Internal round 15 (round 19)
    signal int_add_15;
    int_add_15 <== state[19][0] + poseidon2_rc(19, 0);
    signal int_15_x2;
    int_15_x2 <== int_add_15*int_add_15;
    signal int_15_x4;
    int_15_x4 <== int_15_x2*int_15_x2;
    signal int_15_x5;
    int_15_x5 <== int_15_x4*int_add_15;
    signal int_sum_15;
    int_sum_15 <== int_15_x5 + state[19][1] + state[19][2] + state[19][3];
    state[20][0] <== int_15_x5*poseidon2_internal_diag(0) + int_sum_15;
    state[20][1] <== state[19][1]*poseidon2_internal_diag(1) + int_sum_15;
    state[20][2] <== state[19][2]*poseidon2_internal_diag(2) + int_sum_15;
    state[20][3] <== state[19][3]*poseidon2_internal_diag(3) + int_sum_15;

    // Internal round 16 (round 20)
    signal int_add_16;
    int_add_16 <== state[20][0] + poseidon2_rc(20, 0);
    signal int_16_x2;
    int_16_x2 <== int_add_16*int_add_16;
    signal int_16_x4;
    int_16_x4 <== int_16_x2*int_16_x2;
    signal int_16_x5;
    int_16_x5 <== int_16_x4*int_add_16;
    signal int_sum_16;
    int_sum_16 <== int_16_x5 + state[20][1] + state[20][2] + state[20][3];
    state[21][0] <== int_16_x5*poseidon2_internal_diag(0) + int_sum_16;
    state[21][1] <== state[20][1]*poseidon2_internal_diag(1) + int_sum_16;
    state[21][2] <== state[20][2]*poseidon2_internal_diag(2) + int_sum_16;
    state[21][3] <== state[20][3]*poseidon2_internal_diag(3) + int_sum_16;

    // Internal round 17 (round 21)
    signal int_add_17;
    int_add_17 <== state[21][0] + poseidon2_rc(21, 0);
    signal int_17_x2;
    int_17_x2 <== int_add_17*int_add_17;
    signal int_17_x4;
    int_17_x4 <== int_17_x2*int_17_x2;
    signal int_17_x5;
    int_17_x5 <== int_17_x4*int_add_17;
    signal int_sum_17;
    int_sum_17 <== int_17_x5 + state[21][1] + state[21][2] + state[21][3];
    state[22][0] <== int_17_x5*poseidon2_internal_diag(0) + int_sum_17;
    state[22][1] <== state[21][1]*poseidon2_internal_diag(1) + int_sum_17;
    state[22][2] <== state[21][2]*poseidon2_internal_diag(2) + int_sum_17;
    state[22][3] <== state[21][3]*poseidon2_internal_diag(3) + int_sum_17;

    // Internal round 18 (round 22)
    signal int_add_18;
    int_add_18 <== state[22][0] + poseidon2_rc(22, 0);
    signal int_18_x2;
    int_18_x2 <== int_add_18*int_add_18;
    signal int_18_x4;
    int_18_x4 <== int_18_x2*int_18_x2;
    signal int_18_x5;
    int_18_x5 <== int_18_x4*int_add_18;
    signal int_sum_18;
    int_sum_18 <== int_18_x5 + state[22][1] + state[22][2] + state[22][3];
    state[23][0] <== int_18_x5*poseidon2_internal_diag(0) + int_sum_18;
    state[23][1] <== state[22][1]*poseidon2_internal_diag(1) + int_sum_18;
    state[23][2] <== state[22][2]*poseidon2_internal_diag(2) + int_sum_18;
    state[23][3] <== state[22][3]*poseidon2_internal_diag(3) + int_sum_18;

    // Internal round 19 (round 23)
    signal int_add_19;
    int_add_19 <== state[23][0] + poseidon2_rc(23, 0);
    signal int_19_x2;
    int_19_x2 <== int_add_19*int_add_19;
    signal int_19_x4;
    int_19_x4 <== int_19_x2*int_19_x2;
    signal int_19_x5;
    int_19_x5 <== int_19_x4*int_add_19;
    signal int_sum_19;
    int_sum_19 <== int_19_x5 + state[23][1] + state[23][2] + state[23][3];
    state[24][0] <== int_19_x5*poseidon2_internal_diag(0) + int_sum_19;
    state[24][1] <== state[23][1]*poseidon2_internal_diag(1) + int_sum_19;
    state[24][2] <== state[23][2]*poseidon2_internal_diag(2) + int_sum_19;
    state[24][3] <== state[23][3]*poseidon2_internal_diag(3) + int_sum_19;

    // Internal round 20 (round 24)
    signal int_add_20;
    int_add_20 <== state[24][0] + poseidon2_rc(24, 0);
    signal int_20_x2;
    int_20_x2 <== int_add_20*int_add_20;
    signal int_20_x4;
    int_20_x4 <== int_20_x2*int_20_x2;
    signal int_20_x5;
    int_20_x5 <== int_20_x4*int_add_20;
    signal int_sum_20;
    int_sum_20 <== int_20_x5 + state[24][1] + state[24][2] + state[24][3];
    state[25][0] <== int_20_x5*poseidon2_internal_diag(0) + int_sum_20;
    state[25][1] <== state[24][1]*poseidon2_internal_diag(1) + int_sum_20;
    state[25][2] <== state[24][2]*poseidon2_internal_diag(2) + int_sum_20;
    state[25][3] <== state[24][3]*poseidon2_internal_diag(3) + int_sum_20;

    // Internal round 21 (round 25)
    signal int_add_21;
    int_add_21 <== state[25][0] + poseidon2_rc(25, 0);
    signal int_21_x2;
    int_21_x2 <== int_add_21*int_add_21;
    signal int_21_x4;
    int_21_x4 <== int_21_x2*int_21_x2;
    signal int_21_x5;
    int_21_x5 <== int_21_x4*int_add_21;
    signal int_sum_21;
    int_sum_21 <== int_21_x5 + state[25][1] + state[25][2] + state[25][3];
    state[26][0] <== int_21_x5*poseidon2_internal_diag(0) + int_sum_21;
    state[26][1] <== state[25][1]*poseidon2_internal_diag(1) + int_sum_21;
    state[26][2] <== state[25][2]*poseidon2_internal_diag(2) + int_sum_21;
    state[26][3] <== state[25][3]*poseidon2_internal_diag(3) + int_sum_21;

    // Internal round 22 (round 26)
    signal int_add_22;
    int_add_22 <== state[26][0] + poseidon2_rc(26, 0);
    signal int_22_x2;
    int_22_x2 <== int_add_22*int_add_22;
    signal int_22_x4;
    int_22_x4 <== int_22_x2*int_22_x2;
    signal int_22_x5;
    int_22_x5 <== int_22_x4*int_add_22;
    signal int_sum_22;
    int_sum_22 <== int_22_x5 + state[26][1] + state[26][2] + state[26][3];
    state[27][0] <== int_22_x5*poseidon2_internal_diag(0) + int_sum_22;
    state[27][1] <== state[26][1]*poseidon2_internal_diag(1) + int_sum_22;
    state[27][2] <== state[26][2]*poseidon2_internal_diag(2) + int_sum_22;
    state[27][3] <== state[26][3]*poseidon2_internal_diag(3) + int_sum_22;

    // Internal round 23 (round 27)
    signal int_add_23;
    int_add_23 <== state[27][0] + poseidon2_rc(27, 0);
    signal int_23_x2;
    int_23_x2 <== int_add_23*int_add_23;
    signal int_23_x4;
    int_23_x4 <== int_23_x2*int_23_x2;
    signal int_23_x5;
    int_23_x5 <== int_23_x4*int_add_23;
    signal int_sum_23;
    int_sum_23 <== int_23_x5 + state[27][1] + state[27][2] + state[27][3];
    state[28][0] <== int_23_x5*poseidon2_internal_diag(0) + int_sum_23;
    state[28][1] <== state[27][1]*poseidon2_internal_diag(1) + int_sum_23;
    state[28][2] <== state[27][2]*poseidon2_internal_diag(2) + int_sum_23;
    state[28][3] <== state[27][3]*poseidon2_internal_diag(3) + int_sum_23;

    // Internal round 24 (round 28)
    signal int_add_24;
    int_add_24 <== state[28][0] + poseidon2_rc(28, 0);
    signal int_24_x2;
    int_24_x2 <== int_add_24*int_add_24;
    signal int_24_x4;
    int_24_x4 <== int_24_x2*int_24_x2;
    signal int_24_x5;
    int_24_x5 <== int_24_x4*int_add_24;
    signal int_sum_24;
    int_sum_24 <== int_24_x5 + state[28][1] + state[28][2] + state[28][3];
    state[29][0] <== int_24_x5*poseidon2_internal_diag(0) + int_sum_24;
    state[29][1] <== state[28][1]*poseidon2_internal_diag(1) + int_sum_24;
    state[29][2] <== state[28][2]*poseidon2_internal_diag(2) + int_sum_24;
    state[29][3] <== state[28][3]*poseidon2_internal_diag(3) + int_sum_24;

    // Internal round 25 (round 29)
    signal int_add_25;
    int_add_25 <== state[29][0] + poseidon2_rc(29, 0);
    signal int_25_x2;
    int_25_x2 <== int_add_25*int_add_25;
    signal int_25_x4;
    int_25_x4 <== int_25_x2*int_25_x2;
    signal int_25_x5;
    int_25_x5 <== int_25_x4*int_add_25;
    signal int_sum_25;
    int_sum_25 <== int_25_x5 + state[29][1] + state[29][2] + state[29][3];
    state[30][0] <== int_25_x5*poseidon2_internal_diag(0) + int_sum_25;
    state[30][1] <== state[29][1]*poseidon2_internal_diag(1) + int_sum_25;
    state[30][2] <== state[29][2]*poseidon2_internal_diag(2) + int_sum_25;
    state[30][3] <== state[29][3]*poseidon2_internal_diag(3) + int_sum_25;

    // Internal round 26 (round 30)
    signal int_add_26;
    int_add_26 <== state[30][0] + poseidon2_rc(30, 0);
    signal int_26_x2;
    int_26_x2 <== int_add_26*int_add_26;
    signal int_26_x4;
    int_26_x4 <== int_26_x2*int_26_x2;
    signal int_26_x5;
    int_26_x5 <== int_26_x4*int_add_26;
    signal int_sum_26;
    int_sum_26 <== int_26_x5 + state[30][1] + state[30][2] + state[30][3];
    state[31][0] <== int_26_x5*poseidon2_internal_diag(0) + int_sum_26;
    state[31][1] <== state[30][1]*poseidon2_internal_diag(1) + int_sum_26;
    state[31][2] <== state[30][2]*poseidon2_internal_diag(2) + int_sum_26;
    state[31][3] <== state[30][3]*poseidon2_internal_diag(3) + int_sum_26;

    // Internal round 27 (round 31)
    signal int_add_27;
    int_add_27 <== state[31][0] + poseidon2_rc(31, 0);
    signal int_27_x2;
    int_27_x2 <== int_add_27*int_add_27;
    signal int_27_x4;
    int_27_x4 <== int_27_x2*int_27_x2;
    signal int_27_x5;
    int_27_x5 <== int_27_x4*int_add_27;
    signal int_sum_27;
    int_sum_27 <== int_27_x5 + state[31][1] + state[31][2] + state[31][3];
    state[32][0] <== int_27_x5*poseidon2_internal_diag(0) + int_sum_27;
    state[32][1] <== state[31][1]*poseidon2_internal_diag(1) + int_sum_27;
    state[32][2] <== state[31][2]*poseidon2_internal_diag(2) + int_sum_27;
    state[32][3] <== state[31][3]*poseidon2_internal_diag(3) + int_sum_27;

    // Internal round 28 (round 32)
    signal int_add_28;
    int_add_28 <== state[32][0] + poseidon2_rc(32, 0);
    signal int_28_x2;
    int_28_x2 <== int_add_28*int_add_28;
    signal int_28_x4;
    int_28_x4 <== int_28_x2*int_28_x2;
    signal int_28_x5;
    int_28_x5 <== int_28_x4*int_add_28;
    signal int_sum_28;
    int_sum_28 <== int_28_x5 + state[32][1] + state[32][2] + state[32][3];
    state[33][0] <== int_28_x5*poseidon2_internal_diag(0) + int_sum_28;
    state[33][1] <== state[32][1]*poseidon2_internal_diag(1) + int_sum_28;
    state[33][2] <== state[32][2]*poseidon2_internal_diag(2) + int_sum_28;
    state[33][3] <== state[32][3]*poseidon2_internal_diag(3) + int_sum_28;

    // Internal round 29 (round 33)
    signal int_add_29;
    int_add_29 <== state[33][0] + poseidon2_rc(33, 0);
    signal int_29_x2;
    int_29_x2 <== int_add_29*int_add_29;
    signal int_29_x4;
    int_29_x4 <== int_29_x2*int_29_x2;
    signal int_29_x5;
    int_29_x5 <== int_29_x4*int_add_29;
    signal int_sum_29;
    int_sum_29 <== int_29_x5 + state[33][1] + state[33][2] + state[33][3];
    state[34][0] <== int_29_x5*poseidon2_internal_diag(0) + int_sum_29;
    state[34][1] <== state[33][1]*poseidon2_internal_diag(1) + int_sum_29;
    state[34][2] <== state[33][2]*poseidon2_internal_diag(2) + int_sum_29;
    state[34][3] <== state[33][3]*poseidon2_internal_diag(3) + int_sum_29;

    // Internal round 30 (round 34)
    signal int_add_30;
    int_add_30 <== state[34][0] + poseidon2_rc(34, 0);
    signal int_30_x2;
    int_30_x2 <== int_add_30*int_add_30;
    signal int_30_x4;
    int_30_x4 <== int_30_x2*int_30_x2;
    signal int_30_x5;
    int_30_x5 <== int_30_x4*int_add_30;
    signal int_sum_30;
    int_sum_30 <== int_30_x5 + state[34][1] + state[34][2] + state[34][3];
    state[35][0] <== int_30_x5*poseidon2_internal_diag(0) + int_sum_30;
    state[35][1] <== state[34][1]*poseidon2_internal_diag(1) + int_sum_30;
    state[35][2] <== state[34][2]*poseidon2_internal_diag(2) + int_sum_30;
    state[35][3] <== state[34][3]*poseidon2_internal_diag(3) + int_sum_30;

    // Internal round 31 (round 35)
    signal int_add_31;
    int_add_31 <== state[35][0] + poseidon2_rc(35, 0);
    signal int_31_x2;
    int_31_x2 <== int_add_31*int_add_31;
    signal int_31_x4;
    int_31_x4 <== int_31_x2*int_31_x2;
    signal int_31_x5;
    int_31_x5 <== int_31_x4*int_add_31;
    signal int_sum_31;
    int_sum_31 <== int_31_x5 + state[35][1] + state[35][2] + state[35][3];
    state[36][0] <== int_31_x5*poseidon2_internal_diag(0) + int_sum_31;
    state[36][1] <== state[35][1]*poseidon2_internal_diag(1) + int_sum_31;
    state[36][2] <== state[35][2]*poseidon2_internal_diag(2) + int_sum_31;
    state[36][3] <== state[35][3]*poseidon2_internal_diag(3) + int_sum_31;

    // Internal round 32 (round 36)
    signal int_add_32;
    int_add_32 <== state[36][0] + poseidon2_rc(36, 0);
    signal int_32_x2;
    int_32_x2 <== int_add_32*int_add_32;
    signal int_32_x4;
    int_32_x4 <== int_32_x2*int_32_x2;
    signal int_32_x5;
    int_32_x5 <== int_32_x4*int_add_32;
    signal int_sum_32;
    int_sum_32 <== int_32_x5 + state[36][1] + state[36][2] + state[36][3];
    state[37][0] <== int_32_x5*poseidon2_internal_diag(0) + int_sum_32;
    state[37][1] <== state[36][1]*poseidon2_internal_diag(1) + int_sum_32;
    state[37][2] <== state[36][2]*poseidon2_internal_diag(2) + int_sum_32;
    state[37][3] <== state[36][3]*poseidon2_internal_diag(3) + int_sum_32;

    // Internal round 33 (round 37)
    signal int_add_33;
    int_add_33 <== state[37][0] + poseidon2_rc(37, 0);
    signal int_33_x2;
    int_33_x2 <== int_add_33*int_add_33;
    signal int_33_x4;
    int_33_x4 <== int_33_x2*int_33_x2;
    signal int_33_x5;
    int_33_x5 <== int_33_x4*int_add_33;
    signal int_sum_33;
    int_sum_33 <== int_33_x5 + state[37][1] + state[37][2] + state[37][3];
    state[38][0] <== int_33_x5*poseidon2_internal_diag(0) + int_sum_33;
    state[38][1] <== state[37][1]*poseidon2_internal_diag(1) + int_sum_33;
    state[38][2] <== state[37][2]*poseidon2_internal_diag(2) + int_sum_33;
    state[38][3] <== state[37][3]*poseidon2_internal_diag(3) + int_sum_33;

    // Internal round 34 (round 38)
    signal int_add_34;
    int_add_34 <== state[38][0] + poseidon2_rc(38, 0);
    signal int_34_x2;
    int_34_x2 <== int_add_34*int_add_34;
    signal int_34_x4;
    int_34_x4 <== int_34_x2*int_34_x2;
    signal int_34_x5;
    int_34_x5 <== int_34_x4*int_add_34;
    signal int_sum_34;
    int_sum_34 <== int_34_x5 + state[38][1] + state[38][2] + state[38][3];
    state[39][0] <== int_34_x5*poseidon2_internal_diag(0) + int_sum_34;
    state[39][1] <== state[38][1]*poseidon2_internal_diag(1) + int_sum_34;
    state[39][2] <== state[38][2]*poseidon2_internal_diag(2) + int_sum_34;
    state[39][3] <== state[38][3]*poseidon2_internal_diag(3) + int_sum_34;

    // Internal round 35 (round 39)
    signal int_add_35;
    int_add_35 <== state[39][0] + poseidon2_rc(39, 0);
    signal int_35_x2;
    int_35_x2 <== int_add_35*int_add_35;
    signal int_35_x4;
    int_35_x4 <== int_35_x2*int_35_x2;
    signal int_35_x5;
    int_35_x5 <== int_35_x4*int_add_35;
    signal int_sum_35;
    int_sum_35 <== int_35_x5 + state[39][1] + state[39][2] + state[39][3];
    state[40][0] <== int_35_x5*poseidon2_internal_diag(0) + int_sum_35;
    state[40][1] <== state[39][1]*poseidon2_internal_diag(1) + int_sum_35;
    state[40][2] <== state[39][2]*poseidon2_internal_diag(2) + int_sum_35;
    state[40][3] <== state[39][3]*poseidon2_internal_diag(3) + int_sum_35;

    // Internal round 36 (round 40)
    signal int_add_36;
    int_add_36 <== state[40][0] + poseidon2_rc(40, 0);
    signal int_36_x2;
    int_36_x2 <== int_add_36*int_add_36;
    signal int_36_x4;
    int_36_x4 <== int_36_x2*int_36_x2;
    signal int_36_x5;
    int_36_x5 <== int_36_x4*int_add_36;
    signal int_sum_36;
    int_sum_36 <== int_36_x5 + state[40][1] + state[40][2] + state[40][3];
    state[41][0] <== int_36_x5*poseidon2_internal_diag(0) + int_sum_36;
    state[41][1] <== state[40][1]*poseidon2_internal_diag(1) + int_sum_36;
    state[41][2] <== state[40][2]*poseidon2_internal_diag(2) + int_sum_36;
    state[41][3] <== state[40][3]*poseidon2_internal_diag(3) + int_sum_36;

    // Internal round 37 (round 41)
    signal int_add_37;
    int_add_37 <== state[41][0] + poseidon2_rc(41, 0);
    signal int_37_x2;
    int_37_x2 <== int_add_37*int_add_37;
    signal int_37_x4;
    int_37_x4 <== int_37_x2*int_37_x2;
    signal int_37_x5;
    int_37_x5 <== int_37_x4*int_add_37;
    signal int_sum_37;
    int_sum_37 <== int_37_x5 + state[41][1] + state[41][2] + state[41][3];
    state[42][0] <== int_37_x5*poseidon2_internal_diag(0) + int_sum_37;
    state[42][1] <== state[41][1]*poseidon2_internal_diag(1) + int_sum_37;
    state[42][2] <== state[41][2]*poseidon2_internal_diag(2) + int_sum_37;
    state[42][3] <== state[41][3]*poseidon2_internal_diag(3) + int_sum_37;

    // Internal round 38 (round 42)
    signal int_add_38;
    int_add_38 <== state[42][0] + poseidon2_rc(42, 0);
    signal int_38_x2;
    int_38_x2 <== int_add_38*int_add_38;
    signal int_38_x4;
    int_38_x4 <== int_38_x2*int_38_x2;
    signal int_38_x5;
    int_38_x5 <== int_38_x4*int_add_38;
    signal int_sum_38;
    int_sum_38 <== int_38_x5 + state[42][1] + state[42][2] + state[42][3];
    state[43][0] <== int_38_x5*poseidon2_internal_diag(0) + int_sum_38;
    state[43][1] <== state[42][1]*poseidon2_internal_diag(1) + int_sum_38;
    state[43][2] <== state[42][2]*poseidon2_internal_diag(2) + int_sum_38;
    state[43][3] <== state[42][3]*poseidon2_internal_diag(3) + int_sum_38;

    // Internal round 39 (round 43)
    signal int_add_39;
    int_add_39 <== state[43][0] + poseidon2_rc(43, 0);
    signal int_39_x2;
    int_39_x2 <== int_add_39*int_add_39;
    signal int_39_x4;
    int_39_x4 <== int_39_x2*int_39_x2;
    signal int_39_x5;
    int_39_x5 <== int_39_x4*int_add_39;
    signal int_sum_39;
    int_sum_39 <== int_39_x5 + state[43][1] + state[43][2] + state[43][3];
    state[44][0] <== int_39_x5*poseidon2_internal_diag(0) + int_sum_39;
    state[44][1] <== state[43][1]*poseidon2_internal_diag(1) + int_sum_39;
    state[44][2] <== state[43][2]*poseidon2_internal_diag(2) + int_sum_39;
    state[44][3] <== state[43][3]*poseidon2_internal_diag(3) + int_sum_39;

    // Internal round 40 (round 44)
    signal int_add_40;
    int_add_40 <== state[44][0] + poseidon2_rc(44, 0);
    signal int_40_x2;
    int_40_x2 <== int_add_40*int_add_40;
    signal int_40_x4;
    int_40_x4 <== int_40_x2*int_40_x2;
    signal int_40_x5;
    int_40_x5 <== int_40_x4*int_add_40;
    signal int_sum_40;
    int_sum_40 <== int_40_x5 + state[44][1] + state[44][2] + state[44][3];
    state[45][0] <== int_40_x5*poseidon2_internal_diag(0) + int_sum_40;
    state[45][1] <== state[44][1]*poseidon2_internal_diag(1) + int_sum_40;
    state[45][2] <== state[44][2]*poseidon2_internal_diag(2) + int_sum_40;
    state[45][3] <== state[44][3]*poseidon2_internal_diag(3) + int_sum_40;

    // Internal round 41 (round 45)
    signal int_add_41;
    int_add_41 <== state[45][0] + poseidon2_rc(45, 0);
    signal int_41_x2;
    int_41_x2 <== int_add_41*int_add_41;
    signal int_41_x4;
    int_41_x4 <== int_41_x2*int_41_x2;
    signal int_41_x5;
    int_41_x5 <== int_41_x4*int_add_41;
    signal int_sum_41;
    int_sum_41 <== int_41_x5 + state[45][1] + state[45][2] + state[45][3];
    state[46][0] <== int_41_x5*poseidon2_internal_diag(0) + int_sum_41;
    state[46][1] <== state[45][1]*poseidon2_internal_diag(1) + int_sum_41;
    state[46][2] <== state[45][2]*poseidon2_internal_diag(2) + int_sum_41;
    state[46][3] <== state[45][3]*poseidon2_internal_diag(3) + int_sum_41;

    // Internal round 42 (round 46)
    signal int_add_42;
    int_add_42 <== state[46][0] + poseidon2_rc(46, 0);
    signal int_42_x2;
    int_42_x2 <== int_add_42*int_add_42;
    signal int_42_x4;
    int_42_x4 <== int_42_x2*int_42_x2;
    signal int_42_x5;
    int_42_x5 <== int_42_x4*int_add_42;
    signal int_sum_42;
    int_sum_42 <== int_42_x5 + state[46][1] + state[46][2] + state[46][3];
    state[47][0] <== int_42_x5*poseidon2_internal_diag(0) + int_sum_42;
    state[47][1] <== state[46][1]*poseidon2_internal_diag(1) + int_sum_42;
    state[47][2] <== state[46][2]*poseidon2_internal_diag(2) + int_sum_42;
    state[47][3] <== state[46][3]*poseidon2_internal_diag(3) + int_sum_42;

    // Internal round 43 (round 47)
    signal int_add_43;
    int_add_43 <== state[47][0] + poseidon2_rc(47, 0);
    signal int_43_x2;
    int_43_x2 <== int_add_43*int_add_43;
    signal int_43_x4;
    int_43_x4 <== int_43_x2*int_43_x2;
    signal int_43_x5;
    int_43_x5 <== int_43_x4*int_add_43;
    signal int_sum_43;
    int_sum_43 <== int_43_x5 + state[47][1] + state[47][2] + state[47][3];
    state[48][0] <== int_43_x5*poseidon2_internal_diag(0) + int_sum_43;
    state[48][1] <== state[47][1]*poseidon2_internal_diag(1) + int_sum_43;
    state[48][2] <== state[47][2]*poseidon2_internal_diag(2) + int_sum_43;
    state[48][3] <== state[47][3]*poseidon2_internal_diag(3) + int_sum_43;

    // Internal round 44 (round 48)
    signal int_add_44;
    int_add_44 <== state[48][0] + poseidon2_rc(48, 0);
    signal int_44_x2;
    int_44_x2 <== int_add_44*int_add_44;
    signal int_44_x4;
    int_44_x4 <== int_44_x2*int_44_x2;
    signal int_44_x5;
    int_44_x5 <== int_44_x4*int_add_44;
    signal int_sum_44;
    int_sum_44 <== int_44_x5 + state[48][1] + state[48][2] + state[48][3];
    state[49][0] <== int_44_x5*poseidon2_internal_diag(0) + int_sum_44;
    state[49][1] <== state[48][1]*poseidon2_internal_diag(1) + int_sum_44;
    state[49][2] <== state[48][2]*poseidon2_internal_diag(2) + int_sum_44;
    state[49][3] <== state[48][3]*poseidon2_internal_diag(3) + int_sum_44;

    // Internal round 45 (round 49)
    signal int_add_45;
    int_add_45 <== state[49][0] + poseidon2_rc(49, 0);
    signal int_45_x2;
    int_45_x2 <== int_add_45*int_add_45;
    signal int_45_x4;
    int_45_x4 <== int_45_x2*int_45_x2;
    signal int_45_x5;
    int_45_x5 <== int_45_x4*int_add_45;
    signal int_sum_45;
    int_sum_45 <== int_45_x5 + state[49][1] + state[49][2] + state[49][3];
    state[50][0] <== int_45_x5*poseidon2_internal_diag(0) + int_sum_45;
    state[50][1] <== state[49][1]*poseidon2_internal_diag(1) + int_sum_45;
    state[50][2] <== state[49][2]*poseidon2_internal_diag(2) + int_sum_45;
    state[50][3] <== state[49][3]*poseidon2_internal_diag(3) + int_sum_45;

    // Internal round 46 (round 50)
    signal int_add_46;
    int_add_46 <== state[50][0] + poseidon2_rc(50, 0);
    signal int_46_x2;
    int_46_x2 <== int_add_46*int_add_46;
    signal int_46_x4;
    int_46_x4 <== int_46_x2*int_46_x2;
    signal int_46_x5;
    int_46_x5 <== int_46_x4*int_add_46;
    signal int_sum_46;
    int_sum_46 <== int_46_x5 + state[50][1] + state[50][2] + state[50][3];
    state[51][0] <== int_46_x5*poseidon2_internal_diag(0) + int_sum_46;
    state[51][1] <== state[50][1]*poseidon2_internal_diag(1) + int_sum_46;
    state[51][2] <== state[50][2]*poseidon2_internal_diag(2) + int_sum_46;
    state[51][3] <== state[50][3]*poseidon2_internal_diag(3) + int_sum_46;

    // Internal round 47 (round 51)
    signal int_add_47;
    int_add_47 <== state[51][0] + poseidon2_rc(51, 0);
    signal int_47_x2;
    int_47_x2 <== int_add_47*int_add_47;
    signal int_47_x4;
    int_47_x4 <== int_47_x2*int_47_x2;
    signal int_47_x5;
    int_47_x5 <== int_47_x4*int_add_47;
    signal int_sum_47;
    int_sum_47 <== int_47_x5 + state[51][1] + state[51][2] + state[51][3];
    state[52][0] <== int_47_x5*poseidon2_internal_diag(0) + int_sum_47;
    state[52][1] <== state[51][1]*poseidon2_internal_diag(1) + int_sum_47;
    state[52][2] <== state[51][2]*poseidon2_internal_diag(2) + int_sum_47;
    state[52][3] <== state[51][3]*poseidon2_internal_diag(3) + int_sum_47;

    // Internal round 48 (round 52)
    signal int_add_48;
    int_add_48 <== state[52][0] + poseidon2_rc(52, 0);
    signal int_48_x2;
    int_48_x2 <== int_add_48*int_add_48;
    signal int_48_x4;
    int_48_x4 <== int_48_x2*int_48_x2;
    signal int_48_x5;
    int_48_x5 <== int_48_x4*int_add_48;
    signal int_sum_48;
    int_sum_48 <== int_48_x5 + state[52][1] + state[52][2] + state[52][3];
    state[53][0] <== int_48_x5*poseidon2_internal_diag(0) + int_sum_48;
    state[53][1] <== state[52][1]*poseidon2_internal_diag(1) + int_sum_48;
    state[53][2] <== state[52][2]*poseidon2_internal_diag(2) + int_sum_48;
    state[53][3] <== state[52][3]*poseidon2_internal_diag(3) + int_sum_48;

    // Internal round 49 (round 53)
    signal int_add_49;
    int_add_49 <== state[53][0] + poseidon2_rc(53, 0);
    signal int_49_x2;
    int_49_x2 <== int_add_49*int_add_49;
    signal int_49_x4;
    int_49_x4 <== int_49_x2*int_49_x2;
    signal int_49_x5;
    int_49_x5 <== int_49_x4*int_add_49;
    signal int_sum_49;
    int_sum_49 <== int_49_x5 + state[53][1] + state[53][2] + state[53][3];
    state[54][0] <== int_49_x5*poseidon2_internal_diag(0) + int_sum_49;
    state[54][1] <== state[53][1]*poseidon2_internal_diag(1) + int_sum_49;
    state[54][2] <== state[53][2]*poseidon2_internal_diag(2) + int_sum_49;
    state[54][3] <== state[53][3]*poseidon2_internal_diag(3) + int_sum_49;

    // Internal round 50 (round 54)
    signal int_add_50;
    int_add_50 <== state[54][0] + poseidon2_rc(54, 0);
    signal int_50_x2;
    int_50_x2 <== int_add_50*int_add_50;
    signal int_50_x4;
    int_50_x4 <== int_50_x2*int_50_x2;
    signal int_50_x5;
    int_50_x5 <== int_50_x4*int_add_50;
    signal int_sum_50;
    int_sum_50 <== int_50_x5 + state[54][1] + state[54][2] + state[54][3];
    state[55][0] <== int_50_x5*poseidon2_internal_diag(0) + int_sum_50;
    state[55][1] <== state[54][1]*poseidon2_internal_diag(1) + int_sum_50;
    state[55][2] <== state[54][2]*poseidon2_internal_diag(2) + int_sum_50;
    state[55][3] <== state[54][3]*poseidon2_internal_diag(3) + int_sum_50;

    // Internal round 51 (round 55)
    signal int_add_51;
    int_add_51 <== state[55][0] + poseidon2_rc(55, 0);
    signal int_51_x2;
    int_51_x2 <== int_add_51*int_add_51;
    signal int_51_x4;
    int_51_x4 <== int_51_x2*int_51_x2;
    signal int_51_x5;
    int_51_x5 <== int_51_x4*int_add_51;
    signal int_sum_51;
    int_sum_51 <== int_51_x5 + state[55][1] + state[55][2] + state[55][3];
    state[56][0] <== int_51_x5*poseidon2_internal_diag(0) + int_sum_51;
    state[56][1] <== state[55][1]*poseidon2_internal_diag(1) + int_sum_51;
    state[56][2] <== state[55][2]*poseidon2_internal_diag(2) + int_sum_51;
    state[56][3] <== state[55][3]*poseidon2_internal_diag(3) + int_sum_51;

    // Internal round 52 (round 56)
    signal int_add_52;
    int_add_52 <== state[56][0] + poseidon2_rc(56, 0);
    signal int_52_x2;
    int_52_x2 <== int_add_52*int_add_52;
    signal int_52_x4;
    int_52_x4 <== int_52_x2*int_52_x2;
    signal int_52_x5;
    int_52_x5 <== int_52_x4*int_add_52;
    signal int_sum_52;
    int_sum_52 <== int_52_x5 + state[56][1] + state[56][2] + state[56][3];
    state[57][0] <== int_52_x5*poseidon2_internal_diag(0) + int_sum_52;
    state[57][1] <== state[56][1]*poseidon2_internal_diag(1) + int_sum_52;
    state[57][2] <== state[56][2]*poseidon2_internal_diag(2) + int_sum_52;
    state[57][3] <== state[56][3]*poseidon2_internal_diag(3) + int_sum_52;

    // Internal round 53 (round 57)
    signal int_add_53;
    int_add_53 <== state[57][0] + poseidon2_rc(57, 0);
    signal int_53_x2;
    int_53_x2 <== int_add_53*int_add_53;
    signal int_53_x4;
    int_53_x4 <== int_53_x2*int_53_x2;
    signal int_53_x5;
    int_53_x5 <== int_53_x4*int_add_53;
    signal int_sum_53;
    int_sum_53 <== int_53_x5 + state[57][1] + state[57][2] + state[57][3];
    state[58][0] <== int_53_x5*poseidon2_internal_diag(0) + int_sum_53;
    state[58][1] <== state[57][1]*poseidon2_internal_diag(1) + int_sum_53;
    state[58][2] <== state[57][2]*poseidon2_internal_diag(2) + int_sum_53;
    state[58][3] <== state[57][3]*poseidon2_internal_diag(3) + int_sum_53;

    // Internal round 54 (round 58)
    signal int_add_54;
    int_add_54 <== state[58][0] + poseidon2_rc(58, 0);
    signal int_54_x2;
    int_54_x2 <== int_add_54*int_add_54;
    signal int_54_x4;
    int_54_x4 <== int_54_x2*int_54_x2;
    signal int_54_x5;
    int_54_x5 <== int_54_x4*int_add_54;
    signal int_sum_54;
    int_sum_54 <== int_54_x5 + state[58][1] + state[58][2] + state[58][3];
    state[59][0] <== int_54_x5*poseidon2_internal_diag(0) + int_sum_54;
    state[59][1] <== state[58][1]*poseidon2_internal_diag(1) + int_sum_54;
    state[59][2] <== state[58][2]*poseidon2_internal_diag(2) + int_sum_54;
    state[59][3] <== state[58][3]*poseidon2_internal_diag(3) + int_sum_54;

    // Internal round 55 (round 59)
    signal int_add_55;
    int_add_55 <== state[59][0] + poseidon2_rc(59, 0);
    signal int_55_x2;
    int_55_x2 <== int_add_55*int_add_55;
    signal int_55_x4;
    int_55_x4 <== int_55_x2*int_55_x2;
    signal int_55_x5;
    int_55_x5 <== int_55_x4*int_add_55;
    signal int_sum_55;
    int_sum_55 <== int_55_x5 + state[59][1] + state[59][2] + state[59][3];
    state[60][0] <== int_55_x5*poseidon2_internal_diag(0) + int_sum_55;
    state[60][1] <== state[59][1]*poseidon2_internal_diag(1) + int_sum_55;
    state[60][2] <== state[59][2]*poseidon2_internal_diag(2) + int_sum_55;
    state[60][3] <== state[59][3]*poseidon2_internal_diag(3) + int_sum_55;

    // External full round 60
    signal last_add_0_0;
    last_add_0_0 <== state[60][0] + poseidon2_rc(60, 0);
    signal last_0_0_x2;
    last_0_0_x2 <== last_add_0_0*last_add_0_0;
    signal last_0_0_x4;
    last_0_0_x4 <== last_0_0_x2*last_0_0_x2;
    signal last_0_0_x5;
    last_0_0_x5 <== last_0_0_x4*last_add_0_0;
    signal last_add_0_1;
    last_add_0_1 <== state[60][1] + poseidon2_rc(60, 1);
    signal last_0_1_x2;
    last_0_1_x2 <== last_add_0_1*last_add_0_1;
    signal last_0_1_x4;
    last_0_1_x4 <== last_0_1_x2*last_0_1_x2;
    signal last_0_1_x5;
    last_0_1_x5 <== last_0_1_x4*last_add_0_1;
    signal last_add_0_2;
    last_add_0_2 <== state[60][2] + poseidon2_rc(60, 2);
    signal last_0_2_x2;
    last_0_2_x2 <== last_add_0_2*last_add_0_2;
    signal last_0_2_x4;
    last_0_2_x4 <== last_0_2_x2*last_0_2_x2;
    signal last_0_2_x5;
    last_0_2_x5 <== last_0_2_x4*last_add_0_2;
    signal last_add_0_3;
    last_add_0_3 <== state[60][3] + poseidon2_rc(60, 3);
    signal last_0_3_x2;
    last_0_3_x2 <== last_add_0_3*last_add_0_3;
    signal last_0_3_x4;
    last_0_3_x4 <== last_0_3_x2*last_0_3_x2;
    signal last_0_3_x5;
    last_0_3_x5 <== last_0_3_x4*last_add_0_3;
    state[61][0] <== 5*last_0_0_x5 + 7*last_0_1_x5 + last_0_2_x5 + 3*last_0_3_x5;
    state[61][1] <== 4*last_0_0_x5 + 6*last_0_1_x5 + last_0_2_x5 + last_0_3_x5;
    state[61][2] <== last_0_0_x5 + 3*last_0_1_x5 + 5*last_0_2_x5 + 7*last_0_3_x5;
    state[61][3] <== last_0_0_x5 + last_0_1_x5 + 4*last_0_2_x5 + 6*last_0_3_x5;

    // External full round 61
    signal last_add_1_0;
    last_add_1_0 <== state[61][0] + poseidon2_rc(61, 0);
    signal last_1_0_x2;
    last_1_0_x2 <== last_add_1_0*last_add_1_0;
    signal last_1_0_x4;
    last_1_0_x4 <== last_1_0_x2*last_1_0_x2;
    signal last_1_0_x5;
    last_1_0_x5 <== last_1_0_x4*last_add_1_0;
    signal last_add_1_1;
    last_add_1_1 <== state[61][1] + poseidon2_rc(61, 1);
    signal last_1_1_x2;
    last_1_1_x2 <== last_add_1_1*last_add_1_1;
    signal last_1_1_x4;
    last_1_1_x4 <== last_1_1_x2*last_1_1_x2;
    signal last_1_1_x5;
    last_1_1_x5 <== last_1_1_x4*last_add_1_1;
    signal last_add_1_2;
    last_add_1_2 <== state[61][2] + poseidon2_rc(61, 2);
    signal last_1_2_x2;
    last_1_2_x2 <== last_add_1_2*last_add_1_2;
    signal last_1_2_x4;
    last_1_2_x4 <== last_1_2_x2*last_1_2_x2;
    signal last_1_2_x5;
    last_1_2_x5 <== last_1_2_x4*last_add_1_2;
    signal last_add_1_3;
    last_add_1_3 <== state[61][3] + poseidon2_rc(61, 3);
    signal last_1_3_x2;
    last_1_3_x2 <== last_add_1_3*last_add_1_3;
    signal last_1_3_x4;
    last_1_3_x4 <== last_1_3_x2*last_1_3_x2;
    signal last_1_3_x5;
    last_1_3_x5 <== last_1_3_x4*last_add_1_3;
    state[62][0] <== 5*last_1_0_x5 + 7*last_1_1_x5 + last_1_2_x5 + 3*last_1_3_x5;
    state[62][1] <== 4*last_1_0_x5 + 6*last_1_1_x5 + last_1_2_x5 + last_1_3_x5;
    state[62][2] <== last_1_0_x5 + 3*last_1_1_x5 + 5*last_1_2_x5 + 7*last_1_3_x5;
    state[62][3] <== last_1_0_x5 + last_1_1_x5 + 4*last_1_2_x5 + 6*last_1_3_x5;

    // External full round 62
    signal last_add_2_0;
    last_add_2_0 <== state[62][0] + poseidon2_rc(62, 0);
    signal last_2_0_x2;
    last_2_0_x2 <== last_add_2_0*last_add_2_0;
    signal last_2_0_x4;
    last_2_0_x4 <== last_2_0_x2*last_2_0_x2;
    signal last_2_0_x5;
    last_2_0_x5 <== last_2_0_x4*last_add_2_0;
    signal last_add_2_1;
    last_add_2_1 <== state[62][1] + poseidon2_rc(62, 1);
    signal last_2_1_x2;
    last_2_1_x2 <== last_add_2_1*last_add_2_1;
    signal last_2_1_x4;
    last_2_1_x4 <== last_2_1_x2*last_2_1_x2;
    signal last_2_1_x5;
    last_2_1_x5 <== last_2_1_x4*last_add_2_1;
    signal last_add_2_2;
    last_add_2_2 <== state[62][2] + poseidon2_rc(62, 2);
    signal last_2_2_x2;
    last_2_2_x2 <== last_add_2_2*last_add_2_2;
    signal last_2_2_x4;
    last_2_2_x4 <== last_2_2_x2*last_2_2_x2;
    signal last_2_2_x5;
    last_2_2_x5 <== last_2_2_x4*last_add_2_2;
    signal last_add_2_3;
    last_add_2_3 <== state[62][3] + poseidon2_rc(62, 3);
    signal last_2_3_x2;
    last_2_3_x2 <== last_add_2_3*last_add_2_3;
    signal last_2_3_x4;
    last_2_3_x4 <== last_2_3_x2*last_2_3_x2;
    signal last_2_3_x5;
    last_2_3_x5 <== last_2_3_x4*last_add_2_3;
    state[63][0] <== 5*last_2_0_x5 + 7*last_2_1_x5 + last_2_2_x5 + 3*last_2_3_x5;
    state[63][1] <== 4*last_2_0_x5 + 6*last_2_1_x5 + last_2_2_x5 + last_2_3_x5;
    state[63][2] <== last_2_0_x5 + 3*last_2_1_x5 + 5*last_2_2_x5 + 7*last_2_3_x5;
    state[63][3] <== last_2_0_x5 + last_2_1_x5 + 4*last_2_2_x5 + 6*last_2_3_x5;

    // External full round 63
    signal last_add_3_0;
    last_add_3_0 <== state[63][0] + poseidon2_rc(63, 0);
    signal last_3_0_x2;
    last_3_0_x2 <== last_add_3_0*last_add_3_0;
    signal last_3_0_x4;
    last_3_0_x4 <== last_3_0_x2*last_3_0_x2;
    signal last_3_0_x5;
    last_3_0_x5 <== last_3_0_x4*last_add_3_0;
    signal last_add_3_1;
    last_add_3_1 <== state[63][1] + poseidon2_rc(63, 1);
    signal last_3_1_x2;
    last_3_1_x2 <== last_add_3_1*last_add_3_1;
    signal last_3_1_x4;
    last_3_1_x4 <== last_3_1_x2*last_3_1_x2;
    signal last_3_1_x5;
    last_3_1_x5 <== last_3_1_x4*last_add_3_1;
    signal last_add_3_2;
    last_add_3_2 <== state[63][2] + poseidon2_rc(63, 2);
    signal last_3_2_x2;
    last_3_2_x2 <== last_add_3_2*last_add_3_2;
    signal last_3_2_x4;
    last_3_2_x4 <== last_3_2_x2*last_3_2_x2;
    signal last_3_2_x5;
    last_3_2_x5 <== last_3_2_x4*last_add_3_2;
    signal last_add_3_3;
    last_add_3_3 <== state[63][3] + poseidon2_rc(63, 3);
    signal last_3_3_x2;
    last_3_3_x2 <== last_add_3_3*last_add_3_3;
    signal last_3_3_x4;
    last_3_3_x4 <== last_3_3_x2*last_3_3_x2;
    signal last_3_3_x5;
    last_3_3_x5 <== last_3_3_x4*last_add_3_3;
    state[64][0] <== 5*last_3_0_x5 + 7*last_3_1_x5 + last_3_2_x5 + 3*last_3_3_x5;
    state[64][1] <== 4*last_3_0_x5 + 6*last_3_1_x5 + last_3_2_x5 + last_3_3_x5;
    state[64][2] <== last_3_0_x5 + 3*last_3_1_x5 + 5*last_3_2_x5 + 7*last_3_3_x5;
    state[64][3] <== last_3_0_x5 + last_3_1_x5 + 4*last_3_2_x5 + 6*last_3_3_x5;

    state_out[0] <== state[64][0];
    state_out[1] <== state[64][1];
    state_out[2] <== state[64][2];
    state_out[3] <== state[64][3];
}
