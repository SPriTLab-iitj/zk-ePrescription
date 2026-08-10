const circomlib = require("circomlibjs");

async function main() {

    const poseidon = await circomlib.buildPoseidon();

    const R  = BigInt("1111");
    const pk = BigInt("2222");

    const C = BigInt(
        "3860341765330688960022014867996541681492465489926757557674320400299605725994"
    );

    const r  = BigInt("3333");
    const sk = BigInt("4444");

    const e = poseidon.F.toObject(
        poseidon([R, pk, C])
    );

    const s = r + BigInt(e) * sk;

    console.log("Challenge e:");
    console.log(e.toString());

    console.log("\nResponse s:");
    console.log(s.toString());
}

main();
