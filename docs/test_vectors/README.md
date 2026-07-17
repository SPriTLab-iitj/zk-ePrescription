# Golden Test Vectors

This directory stores reproducible development test vectors for the
UltraHonk e-Prescription prototype.

Purpose
-------

These vectors allow developers to verify that changes to the circuit do
not accidentally break correctness.

Current Test Vector
-------------------

Development Doctor

Contains:

- BabyJubJub private key
- public key
- nonce point (R8)
- Schnorr signature
- Poseidon2 challenge
- commitment
- working Prover.toml

Expected Result
---------------

Running

    cd noir/phase4_orchestrator
    nargo execute

should successfully solve the witness and produce the expected public outputs.

These values are ONLY for development.

They MUST NEVER be used in production.
