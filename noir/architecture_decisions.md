Hash Function Decision Update (Locked)
--------------------------------------

Groth16 Baseline:
- Poseidon v1 (circomlib)

UltraHonk Branch:
- Poseidon2 (Barretenberg native black-box implementation)

Rationale:
- Uses each proving system's native optimized hash implementation.
- Commitments are intentionally non-portable across proving systems.
- This is a deliberate methodology choice rather than an implementation limitation.
