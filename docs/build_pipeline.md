
---

# `docs/build_pipeline.md`

```md
# Build Pipeline

## Standard workflow

Every verifier-bearing package follows the same pipeline:

1. `nargo check`
2. `nargo execute`
3. `nargo info`
4. `bb prove`
5. `bb verify`

## Workspace-level commands

From the workspace root:

```bash
nargo fmt --workspace
nargo test --workspace
