#!/usr/bin/env bash
set -euo pipefail

ROOT="$HOME/ultrahonk_hello/noir"
OUTDIR="$ROOT/benchmarks"
TS="$(date +%Y%m%d_%H%M%S)"
REPORT="$OUTDIR/benchmark_$TS.txt"

mkdir -p "$OUTDIR"

echo "Benchmark started at $(date)" | tee "$REPORT"
echo "========================================" | tee -a "$REPORT"

cd "$ROOT"

echo "" | tee -a "$REPORT"
echo "[1/4] nargo execute" | tee -a "$REPORT"
/usr/bin/time -v nargo execute --package phase4_orchestrator \
  >"$OUTDIR/nargo_execute_$TS.log" 2>&1 \
  2>>"$REPORT"

echo "" | tee -a "$REPORT"
echo "[2/4] bb write_vk" | tee -a "$REPORT"
/usr/bin/time -v bb write_vk \
  -b target/phase4_orchestrator.json \
  -o target \
  >"$OUTDIR/write_vk_$TS.log" 2>&1 \
  2>>"$REPORT"

echo "" | tee -a "$REPORT"
echo "[3/4] bb prove" | tee -a "$REPORT"
/usr/bin/time -v bb prove \
  -b target/phase4_orchestrator.json \
  -w target/phase4_orchestrator.gz \
  -o target \
  >"$OUTDIR/prove_$TS.log" 2>&1 \
  2>>"$REPORT"

echo "" | tee -a "$REPORT"
echo "[4/4] bb verify" | tee -a "$REPORT"
/usr/bin/time -v bb verify \
  -k target/vk \
  -p target/proof \
  -i target/public_inputs \
  >"$OUTDIR/verify_$TS.log" 2>&1 \
  2>>"$REPORT"

echo "" | tee -a "$REPORT"
echo "Sizes" | tee -a "$REPORT"
ls -lh target/proof target/public_inputs target/vk target/vk_hash target/phase4_orchestrator.json target/phase4_orchestrator.gz | tee -a "$REPORT"

echo "" | tee -a "$REPORT"
echo "Benchmark finished at $(date)" | tee -a "$REPORT"
echo "Report saved to $REPORT"
