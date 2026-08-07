# Phase 4: Orchestrator

The Orchestrator is the final component in the ePrescription zk-SNARK workflow. It ties together the primitive circuits to evaluate a prescription holistically and generates the final ZK proof used by Pharmacies.

Unlike the independent primitive circuits, the Orchestrator acts as an **enforcement** circuit. Invalid conditions (e.g. invalid signature, expired prescription, invalid medical registry) will result in a hard constraint failure, preventing the generation of a cryptographic proof.

## Workflow
1. Computes the **commitment** hashing the private prescription ID, doctor ID, and medicine code.
2. Evaluates the **policy** to ensure the prescription has not expired and hasn't exceeded its use quota.
3. Verifies the **registry path** to mathematically prove the signing doctor is part of the recognized state medical board.
4. Verifies the **Schnorr Signature** over the commitment to authenticate that the valid doctor signed the specific prescription.
5. Emits the public `commitment` and computes the anti-replay `nullifier`.

## Testing
Positive and negative tests validate both normal flow and active tampering scenarios:
- **Positive test** (`TV-001`): Execution completely succeeds, producing a `.gz` witness and valid proof.
- **Negative tests** (`NT-001` to `NT-005`): Execution deterministically fails, rejecting the proof generation during `nargo execute`.

To run validations:
```bash
cd tests/scripts
./run_positive_suite.sh
./run_negative_suite.sh
```
## Registry Configuration

The current prototype is instantiated with a depth-4 Merkle registry (16 leaves).

The underlying registry verification library (`verify_registry<DEPTH>`) is parameterized over the Merkle depth. During development, both depth-2 and depth-4 configurations were successfully validated using the same verification algorithm, demonstrating scalability without changing the cryptographic logic.


