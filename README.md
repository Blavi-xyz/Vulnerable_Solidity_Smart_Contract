# Demo Vulnerable Somnia Contract

Tiny Foundry project for SomniBounty AI demos on Somnia testnet.

## Vulnerability

`src/VulnerableVault.sol` contains an obvious `tx.origin` authorization bug.

The vulnerable line has this marker:

```solidity
// VULNERABILITY IS HERE: tx.origin based auth can be bypassed by a phishing contract.
// FIX IS: use msg.sender == owner instead of tx.origin == owner.
```

## Test

```bash
forge test
```

## Deploy To Somnia Testnet

```bash
forge script script/Deploy.s.sol:Deploy \
  --rpc-url https://api.infra.testnet.somnia.network/ \
  --broadcast
```

Use a funded deployer wallet. Do not commit private keys.
