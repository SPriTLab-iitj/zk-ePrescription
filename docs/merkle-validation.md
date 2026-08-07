# Merkle Library Validation Report

## Validation Scope
The validation focused on verifying the correctness of the Merkle package in the `zk-ePrescription` project. This includes the unconstrained path extractors, tree builders, and the fully constrained on-chain path verifier.

## Positive Coverage
- **Total Vectors**: 8
- **Scenario**: Valid membership proofs with matching roots.
- **Outcome**: 100% Pass rate. All vectors generate valid UltraHonk proofs.

## Negative Coverage
- **Total Vectors**: 5
- **Scenarios**: 
  - Submitting an invalid leaf for a valid path.
  - Submitting tampered internal hashes in the `MerklePath`.
  - Flipping directional indicators (`dirs`).
  - Comparing a valid path against an incorrect expected root.
- **Outcome**: The Noir verifier strictly rejects all invalid proofs (constraint failures).

## Tree Depths Tested
The suite explicitly tests and proves consistency across generic instantiations of the following depths:
- Depth 2 (4 leaves)
- Depth 3 (8 leaves)
- Depth 4 (16 leaves)

## Security Properties Validated
- **Collision Resistance**: Relies securely on `Poseidon2` hash function implementations.
- **Completeness**: Valid paths are always accepted by the circuit.
- **Soundness**: Modified leaves, hashes, or bits always cause assertion failures. The `dual_mux` correctly enforces directional hashing without enabling index-spoofing attacks.

## Current Limitations
- The library currently tests up to depth 4. Production deployments for large-scale registries (e.g., depth 16 or 32) are supported theoretically but lack empirical gas/compute benchmarking.
- Tree capacity is fixed at compile-time via generic type bounds.

## Future Work
- Expand automated testing to depth 16 and depth 32 to monitor proving time scaling.
- Integrate automated gas cost (backend gate count) benchmarking into the regression suite.
- Optimize the unconstrained builder for extremely large trees if memory limits are hit.
