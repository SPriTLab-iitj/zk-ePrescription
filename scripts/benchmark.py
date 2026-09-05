#!/usr/bin/env python3
from __future__ import annotations

import json
import os
import platform
import re
import shutil
import subprocess
import sys
import tempfile
import time
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

RESULTS_DIR = ROOT / "benchmark" / "results"

CIRCOM_SOURCE = ROOT / "circom" / "circuits" / "08_eprescription_main.circom"
CIRCOM_INPUT = ROOT / "circom" / "inputs" / "eprescription" / "eprescription_depth4_leaf0.json"

NOIR_DIR = ROOT / "noir" / "phase4_orchestrator"
NOIR_VECTOR = NOIR_DIR / "tests" / "positive" / "TV-001.toml"

PTOU_POWER = 15  # 2^15 = 32768, above the current ~18.8k production constraints


def ensure_tool(name: str) -> str:
    path = shutil.which(name)
    if not path:
        raise RuntimeError(f"Required tool not found on PATH: {name}")
    return path


def cmd_version(name: str, args: list[str] | None = None) -> str:
    if args is None:
        args = ["--version"]

    try:
        tool = ensure_tool(name)
        proc = subprocess.run(
            [tool, *args],
            cwd=ROOT,
            text=True,
            capture_output=True,
            check=False,
        )
        text = (proc.stdout + "\n" + proc.stderr).strip()
        return text[:1000]
    except Exception as exc:
        return f"<unavailable: {exc}>"


def timed_run(
    label: str,
    cmd: list[str],
    cwd: Path,
    work_dir: Path,
) -> dict:
    """
    Run a command under GNU /usr/bin/time.
    Records wall time and maximum resident set size.
    """
    time_file = work_dir / f"{label}.time"

    started = time.perf_counter()

    wrapped = [
        "/usr/bin/time",
        "-f",
        "%e\n%M",
        "-o",
        str(time_file),
        *cmd,
    ]

    proc = subprocess.run(
        wrapped,
        cwd=cwd,
        text=True,
        capture_output=True,
        check=False,
    )

    wall = time.perf_counter() - started

    elapsed = wall
    max_rss_kb = None

    if time_file.exists():
        lines = [
            line.strip()
            for line in time_file.read_text().splitlines()
            if line.strip()
        ]

        if len(lines) >= 2:
            try:
                elapsed = float(lines[-2])
            except ValueError:
                pass

            try:
                max_rss_kb = int(lines[-1])
            except ValueError:
                pass

    if proc.returncode != 0:
        details = (proc.stderr or proc.stdout).strip()

        print()
        print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
        print(f" BENCHMARK STAGE FAILED: {label}")
        print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
        print("Command:")
        print(" ".join(cmd))
        print(f"Exit code: {proc.returncode}")
        print("Output:")
        print(details[-10000:])
        print()

        raise RuntimeError(
            f"{label} failed with exit code {proc.returncode}"
        )

    return {
        "elapsed_seconds": elapsed,
        "max_rss_kb": max_rss_kb,
    }


def file_size(path: Path) -> int:
    if not path.exists():
        raise RuntimeError(f"Expected output missing: {path}")
    return path.stat().st_size


def system_info() -> dict:
    mem_total_kb = None
    try:
        for line in Path("/proc/meminfo").read_text().splitlines():
            if line.startswith("MemTotal:"):
                mem_total_kb = int(line.split()[1])
                break
    except Exception:
        pass

    cpu_model = platform.processor() or ""

    try:
        for line in Path("/proc/cpuinfo").read_text().splitlines():
            if re.match(r"model name\s*:", line):
                cpu_model = line.split(":", 1)[1].strip()
                break
            if re.match(r"Hardware\s*:", line) and not cpu_model:
                cpu_model = line.split(":", 1)[1].strip()
                break
    except Exception:
        pass

    return {
        "hostname": platform.node(),
        "arch": platform.machine(),
        "cpu_model": cpu_model,
        "logical_cpus": os.cpu_count(),
        "mem_total_kb": mem_total_kb,
        "os": platform.platform(),
        "kernel": platform.release(),
        "python": sys.version.split()[0],
    }


def git_info() -> dict:
    # Docker images may intentionally omit .git.
    # Benchmarking must remain functional without repository metadata.
    try:
        git_dir = ROOT / ".git"

        if not git_dir.exists():
            return {
                "commit_sha": "unavailable-in-container",
                "working_tree_dirty": None,
            }

        def git(*args: str) -> str:
            proc = subprocess.run(
                ["git", *args],
                cwd=ROOT,
                text=True,
                capture_output=True,
                check=True,
            )
            return proc.stdout.strip()

        return {
            "commit_sha": git("rev-parse", "HEAD"),
            "working_tree_dirty": bool(git("status", "--porcelain")),
        }

    except Exception as exc:
        return {
            "commit_sha": "unavailable",
            "working_tree_dirty": None,
            "error": str(exc),
        }


def _paper_time(data: dict | float | int | str | None) -> str:
    if data is None:
        return "N/A"
    if isinstance(data, dict):
        val = data.get("elapsed_seconds")
        if val is None:
            return "N/A"
        return f"{float(val):.3f}"
    if isinstance(data, (int, float)):
        return f"{float(data):.3f}"
    if isinstance(data, str):
        return data
    return "N/A"


def _kb(value: int | float | dict | str | None) -> str:
    if value is None:
        return "N/A"
    if isinstance(value, dict):
        value = value.get("bytes") or value.get("size")
        if value is None:
            return "N/A"
    if isinstance(value, (int, float)):
        return f"{value / 1024:.2f}"
    if isinstance(value, str):
        try:
            return f"{float(value) / 1024:.2f}"
        except ValueError:
            return value
    return "N/A"


def _peak_rss_mb(section: dict | list | None) -> str:
    if not section:
        return "N/A"
    if isinstance(section, dict):
        items = section.values()
    elif isinstance(section, list):
        items = section
    else:
        return "N/A"

    rss_kb_list = [
        item["max_rss_kb"]
        for item in items
        if isinstance(item, dict)
        and isinstance(item.get("max_rss_kb"), (int, float))
    ]

    if not rss_kb_list:
        return "N/A"

    peak_mb = max(rss_kb_list) / 1024
    return f"{peak_mb:.2f}"



def get_circom_constraints(r1cs: Path) -> int:
    proc = subprocess.run(
        ["snarkjs", "r1cs", "info", str(r1cs)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        check=True,
    )

    output = proc.stdout + "\n" + proc.stderr
    match = re.search(r"Constraints:\s*(\d+)", output)

    if not match:
        raise RuntimeError(
            "Could not extract Circom constraint count from snarkjs r1cs info."
        )

    return int(match.group(1))


def get_noir_circuit_metrics(noir_dir: Path, target: Path) -> dict:
    info = subprocess.run(
        ["nargo", "info"],
        cwd=noir_dir,
        text=True,
        capture_output=True,
        check=True,
    )

    info_output = info.stdout + "\n" + info.stderr

    acir_match = re.search(
        r"\|\s*phase4_orchestrator\s*\|\s*main\s*\|\s*(\d+)\s*\|",
        info_output,
    )

    if not acir_match:
        raise RuntimeError(
            "Could not extract ACIR opcode count for phase4_orchestrator::main "
            "from nargo info."
        )

    gates = subprocess.run(
        [
            "bb",
            "gates",
            "-b",
            str(target / "phase4_orchestrator.json"),
        ],
        cwd=noir_dir,
        text=True,
        capture_output=True,
        check=True,
    )

    gates_output = gates.stdout + "\n" + gates.stderr

    json_start = gates_output.find("{")
    if json_start == -1:
        raise RuntimeError(
            "Could not locate JSON output from bb gates."
        )

    try:
        decoder = json.JSONDecoder()
        gate_data, _ = decoder.raw_decode(gates_output[json_start:])
        function = gate_data["functions"][0]
    except (json.JSONDecodeError, KeyError, IndexError) as exc:
        raise RuntimeError(
            f"Could not parse bb gates output: {gates_output[-5000:]}"
        ) from exc

    return {
        "acir_opcodes": int(acir_match.group(1)),
        "barretenberg_circuit_size": int(function["circuit_size"]),
    }


def print_paper_summary(results: dict) -> None:
    circom = results.get("circom_groth16", {})
    noir = results.get("noir_ultrahonk", {})

    circom_sizes = (
        circom.get("sizes_bytes", {})
        if isinstance(circom, dict)
        else {}
    )

    noir_sizes = (
        noir.get("sizes_bytes", {})
        if isinstance(noir, dict)
        else {}
    )

    circom_metrics = (
        circom.get("circuit_metrics", {})
        if isinstance(circom, dict)
        else {}
    )

    noir_metrics = (
        noir.get("circuit_metrics", {})
        if isinstance(noir, dict)
        else {}
    )

    rows = [
        (
            "Circom constraints",
            str(circom_metrics.get("constraints", "N/A")),
            "N/A",
        ),
        (
            "ACIR opcodes",
            "N/A",
            str(noir_metrics.get("acir_opcodes", "N/A")),
        ),
        (
            "Barretenberg gates",
            "N/A",
            str(noir_metrics.get("barretenberg_circuit_size", "N/A")),
        ),
        (
            "Compilation time (s)",
            _paper_time(circom.get("compile")),
            _paper_time(noir.get("compile")),
        ),
        (
            "Witness generation time (s)",
            _paper_time(circom.get("witness")),
            _paper_time(noir.get("execute")),
        ),
        (
            "Groth16 setup (s)",
            _paper_time(circom.get("groth16_setup")),
            "N/A",
        ),
        (
            "Verification-key export (s)",
            _paper_time(circom.get("vk_export")),
            "Included in proving",
        ),
        (
            "Proving time (s)",
            _paper_time(circom.get("prove")),
            _paper_time(noir.get("prove")),
        ),
        (
            "Verification time (s)",
            _paper_time(circom.get("verify")),
            _paper_time(noir.get("verify")),
        ),
        (
            "Proof size (KB)",
            _kb(circom_sizes.get("proof")),
            _kb(noir_sizes.get("proof")),
        ),
        (
            "Verification key size (KB)",
            _kb(circom_sizes.get("verification_key")),
            _kb(noir_sizes.get("verification_key")),
        ),
        (
            "Peak RSS (MB)",
            _peak_rss_mb(circom),
            _peak_rss_mb(noir),
        ),
    ]

    metric_width = max(
        34,
        max(len(row[0]) for row in rows),
    )
    circom_width = max(
        18,
        max(len(row[1]) for row in rows),
    )
    noir_width = max(
        20,
        max(len(row[2]) for row in rows),
    )

    border = (
        "+"
        + "-" * (metric_width + 2)
        + "+"
        + "-" * (circom_width + 2)
        + "+"
        + "-" * (noir_width + 2)
        + "+"
    )

    print()
    print("============================================================")
    print(" PAPER-READY PERFORMANCE SUMMARY")
    print("============================================================")
    print(border)
    print(
        f"| {'Metric':<{metric_width}} "
        f"| {'Circom / Groth16':<{circom_width}} "
        f"| {'Noir / UltraHonk':<{noir_width}} |"
    )
    print(border)

    for metric, circom_value, noir_value in rows:
        print(
            f"| {metric:<{metric_width}} "
            f"| {circom_value:<{circom_width}} "
            f"| {noir_value:<{noir_width}} |"
        )

    print(border)
    print()
    print("Circuit metrics:")
    print(
        f"  Circom constraints: "
        f"{circom_metrics.get('constraints', 'N/A')}"
    )
    print(
        f"  Noir ACIR opcodes: "
        f"{noir_metrics.get('acir_opcodes', 'N/A')}"
    )
    print(
        f"  Barretenberg circuit size: "
        f"{noir_metrics.get('barretenberg_circuit_size', 'N/A')}"
    )
    print()


def main() -> int:
    for tool in ["node", "circom", "snarkjs", "nargo", "bb"]:
        ensure_tool(tool)

    RESULTS_DIR.mkdir(parents=True, exist_ok=True)

    timestamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")
    result_path = (
        RESULTS_DIR
        / f"benchmark_{platform.machine()}_{timestamp}.json"
    )

    with tempfile.TemporaryDirectory(
        prefix="zkep-benchmark-"
    ) as tmp_dir:
        TMP = Path(tmp_dir)

        # ------------------------------------------------------------
        # CIRCOM / GROTH16
        # ------------------------------------------------------------

        circom_out = TMP / "circom"
        circom_out.mkdir(parents=True, exist_ok=True)

        tau0 = TMP / "powersoftau_0000.ptau"
        tau2 = TMP / "powersoftau_phase2.ptau"

        r1cs = circom_out / "08_eprescription_main.r1cs"
        witness = circom_out / "witness.wtns"

        zkey = circom_out / "08_eprescription_main_0000.zkey"
        vk = circom_out / "verification_key.json"

        proof = circom_out / "proof.json"
        public = circom_out / "public.json"

        results = {
            "schema_version": 1,
            "timestamp_utc": datetime.now(timezone.utc).isoformat(),
            "git": git_info(),
            "environment": system_info(),
            "tool_versions": {
                "node": cmd_version("node"),
                "circom": cmd_version("circom"),
                "snarkjs": cmd_version("snarkjs"),
                "nargo": cmd_version("nargo"),
                "barretenberg_bb": cmd_version("bb"),
            },
            "benchmark_config": {
                "circom_source": str(CIRCOM_SOURCE.relative_to(ROOT)),
                "circom_input": str(CIRCOM_INPUT.relative_to(ROOT)),
                "noir_package": str(NOIR_DIR.relative_to(ROOT)),
                "noir_input": str(NOIR_VECTOR.relative_to(ROOT)),
                "powers_of_tau_curve": "bn128",
                "powers_of_tau_power": PTOU_POWER,
                "powers_of_tau_note": (
                    "Fresh local benchmark prerequisite; not a production ceremony."
                ),
            },
            "circom_groth16": {},
            "noir_ultrahonk": {},
        }

        print()
        print("============================================================")
        print(" CIRCOM / GROTH16 BENCHMARK")
        print("============================================================")

        circom = {}

        print("[1/8] Generating local Powers-of-Tau...")
        circom["ptau_new"] = timed_run(
            "ptau_new",
            [
                "snarkjs",
                "powersoftau",
                "new",
                "bn128",
                str(PTOU_POWER),
                str(tau0),
            ],
            ROOT,
            TMP,
        )

        print("[2/8] Preparing phase 2 PTau...")
        circom["ptau_phase2"] = timed_run(
            "ptau_phase2",
            [
                "snarkjs",
                "powersoftau",
                "prepare",
                "phase2",
                str(tau0),
                str(tau2),
            ],
            ROOT,
            TMP,
        )

        print("[3/8] Compiling Circom circuit...")
        circom["compile"] = timed_run(
            "circom_compile",
            [
                "circom",
                str(CIRCOM_SOURCE),
                "--r1cs",
                "--wasm",
                "--sym",
                "-o",
                str(circom_out),
            ],
            ROOT,
            TMP,
        )

        circom["circuit_metrics"] = {
            "constraints": get_circom_constraints(r1cs),
        }

        wasm = (
            circom_out
            / "08_eprescription_main_js"
            / "08_eprescription_main.wasm"
        )

        witness_js = (
            circom_out
            / "08_eprescription_main_js"
            / "generate_witness.js"
        )

        print("[4/8] Generating Circom witness...")
        circom["witness"] = timed_run(
            "circom_witness",
            [
                "node",
                str(witness_js),
                str(wasm),
                str(CIRCOM_INPUT),
                str(witness),
            ],
            ROOT,
            TMP,
        )

        print("[5/8] Checking witness...")
        circom["witness_check"] = timed_run(
            "circom_witness_check",
            [
                "snarkjs",
                "wtns",
                "check",
                str(r1cs),
                str(witness),
            ],
            ROOT,
            TMP,
        )

        print("[6/8] Fresh Groth16 setup...")
        circom["groth16_setup"] = timed_run(
            "groth16_setup",
            [
                "snarkjs",
                "groth16",
                "setup",
                str(r1cs),
                str(tau2),
                str(zkey),
            ],
            ROOT,
            TMP,
        )

        print("[7/8] Exporting verification key...")
        circom["vk_export"] = timed_run(
            "vk_export",
            [
                "snarkjs",
                "zkey",
                "export",
                "verificationkey",
                str(zkey),
                str(vk),
            ],
            ROOT,
            TMP,
        )

        print("[8/8] Proving + verifying...")
        circom["prove"] = timed_run(
            "groth16_prove",
            [
                "snarkjs",
                "groth16",
                "prove",
                str(zkey),
                str(witness),
                str(proof),
                str(public),
            ],
            ROOT,
            TMP,
        )

        circom["verify"] = timed_run(
            "groth16_verify",
            [
                "snarkjs",
                "groth16",
                "verify",
                str(vk),
                str(public),
                str(proof),
            ],
            ROOT,
            TMP,
        )

        results["circom_groth16"] = {
            **circom,
            "sizes_bytes": {
                "r1cs": file_size(r1cs),
                "witness": file_size(witness),
                "zkey": file_size(zkey),
                "proof": file_size(proof),
                "verification_key": file_size(vk),
                "public": file_size(public),
                "powers_of_tau_phase2": file_size(tau2),
            },
        }

        # ------------------------------------------------------------
        # NOIR / ULTRAHONK
        # ------------------------------------------------------------

        print()
        print("============================================================")
        print(" NOIR / ULTRAHONK BENCHMARK")
        print("============================================================")

        prover_path = NOIR_DIR / "Prover.toml"
        original_prover = (
            prover_path.read_bytes()
            if prover_path.exists()
            else None
        )

        try:
            vector_text = NOIR_VECTOR.read_text()

            # Mirror the existing positive-suite convention:
            # benchmark using the same vector but omit `return =`.
            prover_contents = "\n".join(
                line
                for line in vector_text.splitlines()
                if not re.match(r"^return\s*=", line)
            ) + "\n"

            prover_path.write_text(prover_contents)

            target = NOIR_DIR / "target"

            # Fresh benchmark build/witness/proof state.
            if target.exists():
                shutil.rmtree(target)

            noir = {}

            print("[1/4] Compiling Noir package...")
            noir["compile"] = timed_run(
                "noir_compile",
                ["nargo", "compile"],
                NOIR_DIR,
                TMP,
            )

            noir["circuit_metrics"] = get_noir_circuit_metrics(
                NOIR_DIR,
                target,
            )

            print("[2/4] Generating Noir witness...")
            noir["execute"] = timed_run(
                "noir_execute",
                ["nargo", "execute"],
                NOIR_DIR,
                TMP,
            )

            print("[3/4] Generating UltraHonk proof...")
            noir["prove"] = timed_run(
                "ultrahonk_prove",
                [
                    "bb",
                    "prove",
                    "-b",
                    str(target / "phase4_orchestrator.json"),
                    "-w",
                    str(target / "phase4_orchestrator.gz"),
                    "--write_vk",
                    "-o",
                    str(target),
                ],
                NOIR_DIR,
                TMP,
            )

            print("[4/4] Verifying UltraHonk proof...")
            noir["verify"] = timed_run(
                "ultrahonk_verify",
                [
                    "bb",
                    "verify",
                    "-k",
                    str(target / "vk"),
                    "-p",
                    str(target / "proof"),
                ],
                NOIR_DIR,
                TMP,
            )

            results["noir_ultrahonk"] = {
                **noir,
                "sizes_bytes": {
                    "artifact_json": file_size(
                        target / "phase4_orchestrator.json"
                    ),
                    "witness": file_size(
                        target / "phase4_orchestrator.gz"
                    ),
                    "proof": file_size(
                        target / "proof"
                    ),
                    "verification_key": file_size(
                        target / "vk"
                    ),
                },
            }

        finally:
            # Restore the user's original Prover.toml exactly.
            if original_prover is not None:
                prover_path.write_bytes(original_prover)

    result_path.write_text(
        json.dumps(results, indent=2, sort_keys=True) + "\n"
    )

    print()
    print("============================================================")
    print(" BENCHMARK COMPLETE")
    print("============================================================")
    print_paper_summary(results)

    print(f"Machine-readable result:")
    print(result_path)
    print()

    print("Commit:", results["git"]["commit_sha"])
    print("Dirty tree:", results["git"]["working_tree_dirty"])
    print("Architecture:", results["environment"]["arch"])
    print("CPU:", results["environment"]["cpu_model"])
    print("Logical CPUs:", results["environment"]["logical_cpus"])
    print()

    print("Circom / Groth16:")
    for name, data in results["circom_groth16"].items():
        if isinstance(data, dict) and "elapsed_seconds" in data:
            print(
                f"  {name:20s} "
                f"{data['elapsed_seconds']:.3f}s "
                f"RSS={data['max_rss_kb']} kB"
            )

    print()
    print("Noir / UltraHonk:")
    for name, data in results["noir_ultrahonk"].items():
        if isinstance(data, dict) and "elapsed_seconds" in data:
            print(
                f"  {name:20s} "
                f"{data['elapsed_seconds']:.3f}s "
                f"RSS={data['max_rss_kb']} kB"
            )

    print()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
