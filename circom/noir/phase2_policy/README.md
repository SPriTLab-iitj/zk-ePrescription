# Phase 2: Policy (Evaluation Circuit)

This circuit is responsible for evaluating the validity of an electronic prescription policy based on specific criteria. It is designed purely as an **evaluation circuit**, meaning it deterministically computes the validity of the inputs and returns boolean results, rather than enforcing validity as a circuit constraint.

## Inputs
* `quantity_threshold`: The maximum number of uses/slots allowed for the prescription.
* `slot_index`: The current index/use count being evaluated.
* `expiry_date`: The expiration date of the prescription (in `YYYYMMDD` format).
* `current_date`: The current date (in `YYYYMMDD` format).

## Outputs
Returns a `[bool; 2]` array containing:
1. `quantity_valid`: True if `slot_index < quantity_threshold`.
2. `expiry_valid`: True if `current_date <= expiry_date`.

## Evaluation Principle
A "bad" prescription will still generate a valid cryptographic proof. The circuit proves that it correctly evaluated the policy based on the given inputs. A false output is expected for violated policies and generates a valid ZK-SNARK.

## Tests & Regression
Positive and negative tests have been established under `tests/`.

* **Positive Tests (`tests/positive/`)**: Scenarios where all policies are satisfied (returns `[true, true]`).
* **Negative Tests (`tests/negative/`)**: Scenarios where one or more policies are violated (returns `false` for the corresponding check).

To run validations:
```bash
cd tests/scripts
./run_positive_suite.sh
./run_negative_suite.sh
```
