#!/usr/bin/env python3

from __future__ import annotations

import json
import os
import subprocess
import sys
import tempfile
from pathlib import Path
from textwrap import dedent

try:
    import tomllib
except ModuleNotFoundError:
    print("ERROR: Python 3.11+ required.", file=sys.stderr)
    raise SystemExit(1)

ROOT = Path(__file__).resolve().parents[1]
KAT_FILE = ROOT / "tests" / "test_vectors" / "protocol_kats.toml"
CIRCOM = ROOT / "circom"
COMMON = ROOT / "noir" / "common"

# Make the runner work in a normal WSL shell without requiring
# the caller to manually export the toolchain paths.
os.environ["PATH"] = (
    f"{Path.home()}/.cargo/bin:"
    f"{Path.home()}/.nargo/bin:"
    + os.environ.get("PATH", "")
)


def dec(value) -> str:
    if isinstance(value, int):
        return str(value)
    if isinstance(value, str) and value.lower().startswith("0x"):
        return str(int(value, 16))
    return str(value)


def run(cmd: list[str], cwd: Path | None = None) -> None:
    print("+", " ".join(str(x) for x in cmd))
    subprocess.run(cmd, cwd=cwd, check=True)


def circom_kat(
    name: str,
    circuit_dir: str,
    inputs: dict,
) -> None:
    circuit = CIRCOM / circuit_dir / "main.circom"

    with tempfile.TemporaryDirectory(prefix=f"zkep-kat-{name}-") as td:
        out = Path(td)
        input_file = out / "input.json"

        input_file.write_text(
            json.dumps(
                {key: dec(value) for key, value in inputs.items()},
                indent=2,
            )
            + "\n"
        )

        run([
            "circom",
            str(circuit),
            "--r1cs",
            "--wasm",
            "-o",
            str(out),
        ])

        wasm_dir = out / "main_js"
        witness = out / "witness.wtns"

        run([
            "node",
            str(wasm_dir / "generate_witness.js"),
            str(wasm_dir / "main.wasm"),
            str(input_file),
            str(witness),
        ])

        run([
            "snarkjs",
            "wtns",
            "check",
            str(out / "main.r1cs"),
            str(witness),
        ])

        print(f"PASS Circom: {name}")


def run_circom(kats: dict) -> None:
    print("\n========== CIRCOM SHARED Known Answer Tests (KATs) ==========")

    c = kats["commitment"]
    circom_kat(
        "commitment",
        "tests/commitment_poseidon2",
        {
            "prescription_id": c["prescription_id"],
            "doctor_id": c["doctor_id"],
            "medicine_code": c["medicine_code"],
            "expiry": c["expiry_date"],
            "threshold": c["quantity_threshold"],
            "expected": c["expected"],
        },
    )

    i = kats["identity"]
    circom_kat(
        "identity",
        "tests/identity_poseidon2",
        {
            "patient_secret": i["patient_secret"],
            "expected": i["expected"],
        },
    )

    pb = kats["patient_binding"]
    circom_kat(
        "patient_binding",
        "tests/patient_binding_poseidon2",
        {
            "identity_ref": i["expected"],
            "commitment": c["expected"],
            "expected": pb["expected"],
        },
    )

    n = kats["nullifier"]
    circom_kat(
        "nullifier",
        "tests/nullifier_poseidon2",
        {
            "patient_secret": n["patient_secret"],
            "commitment": c["expected"],
            "slot_index": n["slot_index"],
            "expected": n["expected"],
        },
    )

    r = kats["registry_leaf"]
    circom_kat(
        "registry_leaf",
        "tests/registry_leaf_poseidon2",
        {
            "doctor_id": r["doctor_id"],
            "pubkey_x": r["pubkey_x"],
            "pubkey_y": r["pubkey_y"],
            "expected": r["expected"],
        },
    )

    m = kats["merkle_node"]
    circom_kat(
        "merkle_node",
        "tests/merkle_node_poseidon2",
        {
            "left": m["left"],
            "right": m["right"],
            "expected": m["expected"],
        },
    )

    s = kats["schnorr_challenge"]
    circom_kat(
        "schnorr_challenge",
        "tests/schnorr_challenge_poseidon2",
        {
            "Rx": s["Rx"],
            "Ry": s["Ry"],
            "PKx": s["PKx"],
            "PKy": s["PKy"],
            "commitment": s["commitment"],
            "expected": s["expected"],
        },
    )


def noir_source(kats: dict) -> str:
    c = kats["commitment"]
    i = kats["identity"]
    pb = kats["patient_binding"]
    n = kats["nullifier"]
    r = kats["registry_leaf"]
    m = kats["merkle_node"]
    s = kats["schnorr_challenge"]

    return dedent(
        f"""
        use common::poseidon2_hash::{{
            commitment_hash,
            identity_hash,
            nullifier_hash,
            patient_binding_hash,
            registry_leaf_hash,
            merkle_node_hash,
            poseidon2_hash_raw,
        }};

        #[test]
        fn kat_commitment() {{
            let got = commitment_hash([
                {dec(c["prescription_id"])},
                {dec(c["doctor_id"])},
                {dec(c["medicine_code"])},
                {dec(c["expiry_date"])},
                {dec(c["quantity_threshold"])},
            ]);
            assert(got == {dec(c["expected"])});
        }}

        #[test]
        fn kat_identity() {{
            let got = identity_hash([
                {dec(i["patient_secret"])}
            ]);
            assert(got == {dec(i["expected"])});
        }}

        #[test]
        fn kat_patient_binding() {{
            let identity = identity_hash([
                {dec(pb["patient_secret"])}
            ]);

            let commitment = commitment_hash([
                {dec(pb["prescription_id"])},
                {dec(pb["doctor_id"])},
                {dec(pb["medicine_code"])},
                {dec(pb["expiry_date"])},
                {dec(pb["quantity_threshold"])},
            ]);

            assert(identity == {dec(i["expected"])});
            assert(commitment == {dec(c["expected"])});

            let got = patient_binding_hash([
                identity,
                commitment,
            ]);

            assert(got == {dec(pb["expected"])});
        }}

        #[test]
        fn kat_nullifier() {{
            let commitment = commitment_hash([
                {dec(c["prescription_id"])},
                {dec(c["doctor_id"])},
                {dec(c["medicine_code"])},
                {dec(c["expiry_date"])},
                {dec(c["quantity_threshold"])},
            ]);

            assert(commitment == {dec(c["expected"])});

            let got = nullifier_hash([
                {dec(n["patient_secret"])},
                commitment,
                {dec(n["slot_index"])},
            ]);

            assert(got == {dec(n["expected"])});
        }}

        #[test]
        fn kat_registry_leaf() {{
            let got = registry_leaf_hash(
                {dec(r["doctor_id"])},
                {dec(r["pubkey_x"])},
                {dec(r["pubkey_y"])},
            );

            assert(got == {dec(r["expected"])});
        }}

        #[test]
        fn kat_merkle_node() {{
            let got = merkle_node_hash(
                {dec(m["left"])},
                {dec(m["right"])},
            );

            assert(got == {dec(m["expected"])});
        }}

        #[test]
        fn kat_schnorr_challenge() {{
            let got = poseidon2_hash_raw([
                {dec(s["Rx"])},
                {dec(s["Ry"])},
                {dec(s["PKx"])},
                {dec(s["PKy"])},
                {dec(s["commitment"])},
            ]);

            assert(got == {dec(s["expected"])});
        }}
        """
    )


def run_noir(kats: dict) -> None:
    print("\n========== NOIR SHARED KATs ==========")

    with tempfile.TemporaryDirectory(prefix="zkep-noir-kats-") as td:
        pkg = Path(td)
        src = pkg / "src"
        src.mkdir()

        (pkg / "Nargo.toml").write_text(
            dedent(
                f"""
                [package]
                name = "zkep_shared_kats"
                type = "bin"

                [dependencies]
                common = {{ path = "{COMMON}" }}
                """
            ).strip()
            + "\n"
        )

        (src / "main.nr").write_text(noir_source(kats))

        run(["nargo", "test"], cwd=pkg)

    print("PASS Noir: all seven shared protocol Known Answer Tests (KATs)")


def main() -> int:
    if not KAT_FILE.exists():
        print(f"ERROR: missing {KAT_FILE}", file=sys.stderr)
        return 1

    kats = tomllib.loads(KAT_FILE.read_text())

    required = {
        "commitment",
        "identity",
        "patient_binding",
        "nullifier",
        "registry_leaf",
        "merkle_node",
        "schnorr_challenge",
    }

    missing = sorted(required - set(kats))
    if missing:
        print(
            "ERROR: missing KAT sections: " + ", ".join(missing),
            file=sys.stderr,
        )
        return 1

    run_circom(kats)
    run_noir(kats)

    print("\n========== ALL SHARED PROTOCOL Known Answer Tests (KATs) PASSED ==========")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
