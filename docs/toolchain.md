# Toolchain

This project is built on a frozen Noir + Barretenberg stack chosen for stability and reproducibility.

## Frozen versions

- Noir / nargo: `1.0.0-beta.22`
- noirc: `1.0.0-beta.22`
- Barretenberg / bb: `5.0.0-nightly.20260522`
- Environment: WSL Ubuntu on Windows

## Installation commands

Install Noir:

```bash
curl -L https://raw.githubusercontent.com/noir-lang/noirup/main/install | bash
source ~/.bashrc
noirup --version 1.0.0-beta.22
