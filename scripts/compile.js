const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

const buildDir = path.join(__dirname, '../build');
if (!fs.existsSync(buildDir)) {
    fs.mkdirSync(buildDir, { recursive: true });
}

const circuitPath = path.join(__dirname, '../circuits/prescription.circom');
// The compiled circom compiler path inside WSL
const circomPath = '/home/skris/zk-eprescription/ultra_plonk/circom/target/release/circom';

console.log('Compiling prescription.circom in WSL...');
// Convert paths to WSL-friendly format
const compileCmd = `wsl ${circomPath} /home/skris/zk-eprescription/circuits/prescription.circom --r1cs --wasm --sym --output /home/skris/zk-eprescription/build`;

console.log(`Executing: ${compileCmd}`);
try {
    execSync(compileCmd, { stdio: 'inherit' });
    console.log('Circuit compiled successfully!');
} catch (err) {
    console.error('Failed to compile circuit:', err);
    process.exit(1);
}
