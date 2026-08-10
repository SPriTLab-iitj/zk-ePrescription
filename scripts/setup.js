const { execFileSync } = require('child_process');
const fs = require('fs');
const path = require('path');

const buildDir = path.join(__dirname, '../build');
if (!fs.existsSync(buildDir)) {
    fs.mkdirSync(buildDir, { recursive: true });
}

// Check if prescription.r1cs exists
const r1csPath = path.join(buildDir, 'prescription.r1cs');
if (!fs.existsSync(r1csPath)) {
    console.error('Error: build/prescription.r1cs not found! Run compile.js first.');
    process.exit(1);
}

const snarkjsCliPath = path.resolve(__dirname, '../node_modules/snarkjs/build/cli.cjs');

const runSnarkJS = (args) => {
    console.log(`Executing: node snarkjs.js ${args.join(' ')}`);
    execFileSync('node', [snarkjsCliPath, ...args], { stdio: 'inherit', cwd: buildDir });
};

try {
    console.log('=== Starting Powers of Tau Setup ===');
    // 1. New Powers of Tau ceremony with 2^15 constraints
    runSnarkJS(['powersoftau', 'new', 'bn128', '15', 'pot15_0000.ptau', '-v']);
    
    // 2. Contribute to ceremony
    runSnarkJS(['powersoftau', 'contribute', 'pot15_0000.ptau', 'pot15_0001.ptau', '--name=First Contribution', '-v', '-e=some_random_entropy']);
    
    // 3. Prepare Phase 2
    runSnarkJS(['powersoftau', 'prepare', 'phase2', 'pot15_0001.ptau', 'pot15_final.ptau', '-v']);

    console.log('=== PLONK Proving Key Setup ===');
    // 4. PLONK Setup
    runSnarkJS(['plonk', 'setup', 'prescription.r1cs', 'pot15_final.ptau', 'prescription_plonk.zkey']);
    
    // 5. Export PLONK Verification Key
    runSnarkJS(['zkey', 'export', 'verificationkey', 'prescription_plonk.zkey', 'verification_key_plonk.json']);

    console.log('=== Groth16 Proving Key Setup ===');
    // 6. Groth16 Setup
    runSnarkJS(['groth16', 'setup', 'prescription.r1cs', 'pot15_final.ptau', 'prescription_groth16_0000.zkey']);
    
    // 7. Contribute to Groth16 zkey
    runSnarkJS(['zkey', 'contribute', 'prescription_groth16_0000.zkey', 'prescription_groth16.zkey', '--name=First Contribution', '-v', '-e=more_random_entropy']);
    
    // 8. Export Groth16 Verification Key
    runSnarkJS(['zkey', 'export', 'verificationkey', 'prescription_groth16.zkey', 'verification_key_groth16.json']);

    console.log('=== Cryptographic Setup Completed Successfully! ===');
} catch (err) {
    console.error('Setup failed:', err);
    process.exit(1);
}
