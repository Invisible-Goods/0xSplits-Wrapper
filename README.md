# 0xSplits Wrapper

features:

- gas-free ([EIP 2771](https://eips.ethereum.org/EIPS/eip-2771))
- - configured for [Biconomy](https://docs.biconomy.io/misc/contract-addresses#eip-2771-contracts)
- [0xSplits](https://github.com/0xSplits)
- upgradeable
- non-upgradeable

## Setup

- `git clone`
- `npm i`
- modify `scripts/deploy` with correct initializer info.
- create `.env` file in root.
- add env variables (see below).

## Required `.env` variables.

- create `.env` in root of project.

```
TESTNET_PRIVATE_KEY=
MAINNET_PRIVATE_KEY=
```

## Deploy

### Non-Upgradeable

- `npx hardhat run --network mumbai scripts/deploy.js`

### Upgradeable

- `npx hardhat run --network mumbai scripts/deploy-upgradeable.js`

## Upgrade (only for upgradeable)

- modify address in `scripts/upgrade`
- `npx hardhat run --network mumba scripts/upgrade.js`
