#!/usr/bin/env bash
set -euo pipefail

ROOT="$HOME/ultrahonk_hello/noir"
OUTDIR="$ROOT/benchmarks"
TS="$(date -u +%Y%m%dT%H%M%SZ)"
RUN_DIR="$OUTDIR/run_$TS"
CSV="$OUTDIR/summary.csv"

mkdir -p "$OUTDIR" "$RUN_DIR"

# Always start from the golden witness
cp "$ROOT/tests/regression/positive/Prover.toml" \
   "$ROOT/phase4_orchestrator/Prover.toml"

run_stage() {
    local name="$1"
    shift
    /usr/bin/time -v -o "$RUN_DIR/${name}.time" "$@" \
        >"$RUN_DIR/${name}.log" 2>&1
}

echo "Benchmark started at $(date -u)" | tee "$RUN_DIR/report.txt"
echo "========================================" | tee -a "$RUN_DIR/report.txt"

cd "$ROOT"

echo "[1/4] nargo execute" | tee -a "$RUN_DIR/report.txt"
run_stage nargo_execute nargo execute --package phase4_orchestrator

echo "[2/4] bb write_vk" | tee -a "$RUN_DIR/report.txt"
run_stage write_vk bb write_vk -b target/phase4_orchestrator.json -o target

echo "[3/4] bb prove" | tee -a "$RUN_DIR/report.txt"
run_stage prove bb prove -b target/phase4_orchestrator.json -w target/phase4_orchestrator.gz -o target

echo "[4/4] bb verify" | tee -a "$RUN_DIR/report.txt"
run_stage verify bb verify -k target/vk -p target/proof -i target/public_inputs

proof_kb="$(du -k target/proof | cut -f1)"
vk_kb="$(du -k target/vk | cut -f1)"

ls -lh target/proof target/public_inputs target/vk target/vk_hash \
      target/phase4_orchestrator.json target/phase4_orchestrator.gz \
      | tee -a "$RUN_DIR/report.txt"

python3 - "$CSV" "$TS" "$RUN_DIR" "$proof_kb" "$vk_kb" <<'PY'
import csv
import os
import re
import sys
from pathlib import Path

csv_path = Path(sys.argv[1])
timestamp = sys.argv[2]
run_dir = Path(sys.argv[3])
proof_kb = int(sys.argv[4])
vk_kb = int(sys.argv[5])

def parse_timefile(path: Path):
    text = path.read_text()

    elapsed_m = re.search(r'Elapsed \(wall clock\) time .*: ([0-9]+):([0-9]+)\.([0-9]+)|Elapsed \(wall clock\) time .*: ([0-9]+):([0-9]+):([0-9]+)', text)
    # Handle 0:00.61 and 1:02:03 styles
    elapsed = None
    m1 = re.search(r'Elapsed \(wall clock\) time .*: ([0-9]+):([0-9]+)\.([0-9]+)', text)
    if m1:
        mins = int(m1.group(1))
        secs = int(m1.group(2))
        frac = float("0." + m1.group(3))
        elapsed = mins * 60 + secs + frac
    else:
        m2 = re.search(r'Elapsed \(wall clock\) time .*: ([0-9]+):([0-9]+):([0-9]+)', text)
        if m2:
            hrs = int(m2.group(1))
            mins = int(m2.group(2))
            secs = int(m2.group(3))
            elapsed = hrs * 3600 + mins * 60 + secs

    rss_m = re.search(r'Maximum resident set size \(kbytes\): ([0-9]+)', text)
    max_rss_kb = int(rss_m.group(1)) if rss_m else None

    if elapsed is None:
        raise SystemExit(f"Could not parse elapsed time from {path}")

    return elapsed, max_rss_kb

execute_s, execute_mem_kb = parse_timefile(run_dir / "nargo_execute.time")
writevk_s, writevk_mem_kb = parse_timefile(run_dir / "write_vk.time")
prove_s, prove_mem_kb = parse_timefile(run_dir / "prove.time")
verify_s, verify_mem_kb = parse_timefile(run_dir / "verify.time")

header = [
    "timestamp",
    "execute_s",
    "writevk_s",
    "prove_s",
    "verify_s",
    "execute_mem_mb",
    "writevk_mem_mb",
    "prove_mem_mb",
    "verify_mem_mb",
    "proof_kb",
    "vk_kb",
]

row = {
    "timestamp": timestamp,
    "execute_s": f"{execute_s:.3f}",
    "writevk_s": f"{writevk_s:.3f}",
    "prove_s": f"{prove_s:.3f}",
    "verify_s": f"{verify_s:.3f}",
    "execute_mem_mb": f"{execute_mem_kb / 1024:.2f}",
    "writevk_mem_mb": f"{writevk_mem_kb / 1024:.2f}",
    "prove_mem_mb": f"{prove_mem_kb / 1024:.2f}",
    "verify_mem_mb": f"{verify_mem_kb / 1024:.2f}",
    "proof_kb": str(proof_kb),
    "vk_kb": str(vk_kb),
}

write_header = not csv_path.exists()
with csv_path.open("a", newline="") as f:
    w = csv.DictWriter(f, fieldnames=header)
    if write_header:
        w.writeheader()
    w.writerow(row)

print("Wrote CSV row to", csv_path)
PY

echo "Benchmark finished at $(date -u)" | tee -a "$RUN_DIR/report.txt"
echo "Run dir: $RUN_DIR" | tee -a "$RUN_DIR/report.txt"
