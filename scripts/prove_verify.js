const fs = require('fs');
const path = require('path');
const { plonk, groth16 } = require('snarkjs');
const { buildEddsa, buildPoseidon, buildBabyjub } = require('circomlibjs');

// Helper to format BigInts for JSON serialization
function stringifyBigInts(obj) {
    if (typeof obj === 'bigint') {
        return obj.toString();
    } else if (Array.isArray(obj)) {
        return obj.map(stringifyBigInts);
    } else if (typeof obj === 'object' && obj !== null) {
        const newObj = {};
        for (const key in obj) {
            newObj[key] = stringifyBigInts(obj[key]);
        }
        return newObj;
    }
    return obj;
}

// Simple Merkle Tree generation using Poseidon hash
function buildMerkleTree(leaves, poseidon, depth) {
    let currentLevel = leaves.map(x => BigInt(x));
    const tree = [currentLevel];
    
    for (let level = 0; level < depth; level++) {
        const nextLevel = [];
        for (let i = 0; i < currentLevel.length; i += 2) {
            const left = currentLevel[i];
            const right = currentLevel[i + 1] !== undefined ? currentLevel[i + 1] : 0n;
            const parentHash = poseidon.F.toObject(poseidon([left, right]));
            nextLevel.push(parentHash);
        }
        currentLevel = nextLevel;
        tree.push(currentLevel);
    }
    
    return tree;
}

function getMerklePath(tree, index, depth) {
    const pathElements = [];
    const pathIndices = [];
    let idx = index;
    
    for (let level = 0; level < depth; level++) {
        const currentLevel = tree[level];
        const isRight = idx % 2;
        const siblingIdx = isRight ? idx - 1 : idx + 1;
        
        const sibling = currentLevel[siblingIdx] !== undefined ? currentLevel[siblingIdx] : 0n;
        pathElements.push(sibling);
        pathIndices.push(isRight);
        
        idx = Math.floor(idx / 2);
    }
    
    const root = tree[depth][0];
    return { root, pathElements, pathIndices };
}

async function run() {
    console.log('Initializing cryptographic libraries...');
    const eddsa = await buildEddsa();
    const poseidon = await buildPoseidon();
    const babyJub = await buildBabyjub();
    
    const F = babyJub.F;

    console.log('Generating Doctor Registry...');
    // Create an authorized doctor (Doctor A) and an unauthorized doctor (Doctor B)
    const docAPriv = Buffer.from('0000000000000000000000000000000000000000000000000000000000000001', 'hex');
    const docBPriv = Buffer.from('0000000000000000000000000000000000000000000000000000000000000002', 'hex');
    
    const docAPub = eddsa.prv2pub(docAPriv);
    const docBPub = eddsa.prv2pub(docBPriv);
    
    const docAId = 101n;
    const docBId = 102n;
    
    // Compute leaves
    // Leaf = Poseidon(doctorId, doctorPkX, doctorPkY)
    const leafA = poseidon.F.toObject(poseidon([docAId, F.toObject(docAPub[0]), F.toObject(docAPub[1])]));
    const leafB = poseidon.F.toObject(poseidon([docBId, F.toObject(docBPub[0]), F.toObject(docBPub[1])]));
    
    // Construct Merkle Tree of depth 10 (1024 leaves)
    const depth = 10;
    const totalLeaves = 1 << depth;
    const leaves = new Array(totalLeaves).fill(0n);
    
    // Place Doctor A at index 3, Doctor B (revoked/unauthorized) is NOT in the tree
    leaves[3] = leafA;
    
    const tree = buildMerkleTree(leaves, poseidon, depth);
    const root = tree[depth][0];
    console.log(`Merkle Root: ${root.toString()}`);
    
    // Get Merkle path for Doctor A (index 3)
    const pathA = getMerklePath(tree, 3, depth);

    console.log('Generating Patient & Prescription Data...');
    const patientSecret = 123456789n;
    const domainSeparator = 42n;
    
    // 1. Identity Token = Poseidon(patientSecret, domainSeparator)
    const identityToken = poseidon.F.toObject(poseidon([patientSecret, domainSeparator]));
    
    // Prescription parameters
    const prescriptionId = 987654321n;
    const medicineCode = 55555n;
    const medicineQty = 3n;
    const expiry = 1800000000n; // future timestamp
    const threshold = 5n; // T = 5
    const registryVersion = 1n;
    
    // 2. Commitment = Poseidon(prescriptionId, identityToken, medicineCode, medicineQty, expiry, threshold, registryVersion)
    const commitmentHash = poseidon([
        prescriptionId,
        identityToken,
        medicineCode,
        medicineQty,
        expiry,
        threshold,
        registryVersion
    ]);
    const commitment = poseidon.F.toObject(commitmentHash);
    
    // 3. Nullifier = Poseidon(patientSecret, commitment, redemptionIndex, domainSeparator)
    const redemptionIndex = 0n; // i = 0 (first redemption)
    const nullifier = poseidon.F.toObject(poseidon([
        patientSecret,
        commitment,
        redemptionIndex,
        domainSeparator
    ]));

    // 4. Doctor signs the commitment using Poseidon EdDSA
    console.log('Signing commitment with Doctor private key...');
    const signature = eddsa.signPoseidon(docAPriv, commitmentHash);
    
    // Format circuit inputs
    const circuitInputs = {
        commitment: commitment,
        identityToken: identityToken,
        nullifier: nullifier,
        expiry: expiry,
        threshold: threshold,
        registryVersion: registryVersion,
        merkleRoot: pathA.root,
        redemptionIndex: redemptionIndex,
        domainSeparator: domainSeparator,
        
        // Selective Disclosure Flags & Disclosed Fields
        discloseMedicineCodeFlag: 1n, // Disclose medicine code
        discloseMedicineQtyFlag: 0n,  // Do not disclose qty (hide it)
        disclosedMedicineCode: medicineCode,
        disclosedMedicineQty: 0n,     // Must match (discloseFlag * medicineQty) -> (0 * 3) = 0
        
        // Private inputs
        patientSecret: patientSecret,
        prescriptionId: prescriptionId,
        medicineCode: medicineCode,
        medicineQty: medicineQty,
        
        doctorId: docAId,
        doctorPkX: F.toObject(docAPub[0]),
        doctorPkY: F.toObject(docAPub[1]),
        
        merklePathElements: pathA.pathElements,
        merklePathIndices: pathA.pathIndices,
        
        sigR8x: F.toObject(signature.R8[0]),
        sigR8y: F.toObject(signature.R8[1]),
        sigS: signature.S
    };

    // Save test inputs
    const testdataDir = path.join(__dirname, '../testdata');
    if (!fs.existsSync(testdataDir)) {
        fs.mkdirSync(testdataDir, { recursive: true });
    }
    fs.writeFileSync(
        path.join(testdataDir, 'input.json'), 
        JSON.stringify(stringifyBigInts(circuitInputs), null, 2)
    );
    console.log('Saved test input to testdata/input.json');

    // Run End-to-End Proving and Verification
    const buildDir = path.join(__dirname, '../build');
    const wasmPath = path.join(buildDir, 'prescription_js/prescription.wasm');
    const plonkZkeyPath = path.join(buildDir, 'prescription_plonk.zkey');
    const groth16ZkeyPath = path.join(buildDir, 'prescription_groth16.zkey');
    const plonkVKeyPath = path.join(buildDir, 'verification_key_plonk.json');
    const groth16VKeyPath = path.join(buildDir, 'verification_key_groth16.json');

    if (!fs.existsSync(wasmPath)) {
        console.log('\n[!] Compiled WASM file not found. Skipping proof generation.');
        console.log('Please compile the circuits first: node scripts/compile.js && node scripts/setup.js');
        return;
    }

    console.log('\n=========================================');
    console.log('       Running End-to-End Proofs         ');
    console.log('=========================================');

    // --- PLONK ---
    console.log('\nGenerating PLONK proof...');
    const startTimePlonk = Date.now();
    const { proof: plonkProof, publicSignals: plonkPublic } = await plonk.fullProve(
        stringifyBigInts(circuitInputs), 
        wasmPath, 
        plonkZkeyPath
    );
    console.log(`PLONK Proving Time: ${Date.now() - startTimePlonk}ms`);
    
    console.log('Verifying PLONK proof...');
    const plonkVKey = JSON.parse(fs.readFileSync(plonkVKeyPath));
    const plonkVerifyStart = Date.now();
    const isPlonkVerified = await plonk.verify(plonkVKey, plonkPublic, plonkProof);
    console.log(`PLONK Verification Time: ${Date.now() - plonkVerifyStart}ms`);
    console.log(`PLONK Proof Verified successfully: ${isPlonkVerified}`);

    // --- Groth16 ---
    console.log('\nGenerating Groth16 proof...');
    const startTimeGroth16 = Date.now();
    const { proof: groth16Proof, publicSignals: groth16Public } = await groth16.fullProve(
        stringifyBigInts(circuitInputs), 
        wasmPath, 
        groth16ZkeyPath
    );
    console.log(`Groth16 Proving Time: ${Date.now() - startTimeGroth16}ms`);
    
    console.log('Verifying Groth16 proof...');
    const groth16VKey = JSON.parse(fs.readFileSync(groth16VKeyPath));
    const groth16VerifyStart = Date.now();
    const isGroth16Verified = await groth16.verify(groth16VKey, groth16Public, groth16Proof);
    console.log(`Groth16 Verification Time: ${Date.now() - groth16VerifyStart}ms`);
    console.log(`Groth16 Proof Verified successfully: ${isGroth16Verified}`);
}

run().catch(err => {
    console.error('Error running proving flow:', err);
});
