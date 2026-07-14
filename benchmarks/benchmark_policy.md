# Benchmarking Policy

## Purpose

This document defines the benchmarking methodology used throughout the implementation.

The policy is frozen before implementation begins and must remain consistent across all phases to ensure fair comparison.

---

## Metrics Collected

For every implementation phase the following metrics shall be recorded.

### Functional

- Successful compilation
- Successful witness generation
- Successful proof generation
- Successful proof verification

---

### Performance

- Witness generation time
- Verification key generation time
- Proof generation time
- Peak memory during proving
- Peak memory during verification

---

### Artifact Information

- Circuit JSON
- Witness
- Verification key
- Verification key hash
- Public inputs
- Proof

---

## Measurement Environment

Each benchmark must include

- Noir version
- Barretenberg version
- Operating system
- CPU
- RAM

---

## Measurement Rules

- Use identical hardware whenever possible.
- Record timings directly from command output.
- Do not average results unless multiple runs are intentionally performed.
- Record the exact command used.
- Preserve generated artifacts.

---

## Benchmark Frequency

Benchmarks are collected once after each implementation phase is completed.

Phase 1
Phase 2
Phase 3
Phase 4
Phase 5
Phase 6

---

## Research Objective

These benchmark results support the evaluation chapter of the thesis by providing reproducible implementation measurements.
