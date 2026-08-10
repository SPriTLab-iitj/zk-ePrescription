const fs = require("fs");
const circomlib = require("circomlibjs");

async function main() {
    const poseidon = await circomlib.buildPoseidon();
    const F = poseidon.F;

    const DEPTH = 8;
    const LEAVES = 1 << DEPTH;

    // Create 256 deterministic doctor leaves.
    const leaves = [];

    for (let i = 0; i < LEAVES; i++) {
        const doctorId = 5001 + i;
        leaves.push(F.toString(poseidon([doctorId])));
    }

    // Build tree levels.
    let level = leaves.slice();
    const levels = [level];

    while (level.length > 1) {
        const next = [];

        for (let i = 0; i < level.length; i += 2) {
            next.push(
                F.toString(
                    poseidon([
                        level[i],
                        level[i + 1]
                    ])
                )
            );
        }

        level = next;
        levels.push(level);
    }

    const root = level[0];

    // Proof for leaf 0.
    const pathElements = [];
    const pathIndices = [];

    let index = 0;

    for (let depth = 0; depth < DEPTH; depth++) {
        const siblingIndex = index ^ 1;

        pathElements.push(levels[depth][siblingIndex]);
        pathIndices.push(index & 1);

        index = Math.floor(index / 2);
    }

    const input = {
        prescription_id: "1001",
        doctor_id: "5001",
        medicine_code: "123",
        current_date: "20260630",
        expiry: "20261231",
        threshold: "3",

        patient_secret: "12345",
        slot_index: "0",

        doctor_leaf: leaves[0],
        pathElements,
        pathIndices,
        root,

        disclosed_medicine_code: "123",

        // Existing valid Schnorr values.
        Rx: "3786052435012899366340248208277520368404678617497448646358239296295828943121",
        Ry: "16449606152468185267122726090513598979225798443847928573493676725305587856616",
        PKx: "15919299401931535325513703139194931338293993994510664661086800834970360591752",
        PKy: "1645780246786685895560641778865228215443840970280597910012614014295481144366",
        s: "1651190663247114680016725035179813151900382407855613195016541409860491445008"
    };

    fs.writeFileSync(
        "inputs/eprescription_depth8_leaf0.json",
        JSON.stringify(input, null, 2)
    );

    console.log("Depth:", DEPTH);
    console.log("Leaves:", LEAVES);
    console.log("Root:", root);
    console.log("Path elements:", pathElements.length);
    console.log("Path indices:", pathIndices);
    console.log("Written: inputs/eprescription_depth8_leaf0.json");
}

main().catch((err) => {
    console.error(err);
    process.exit(1);
});
