# 0xSplits Wrapper

features:

- gas-free ([EIP 2771](https://eips.ethereum.org/EIPS/eip-2771))
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

- `npx hardhat run --network mumbai scripts/deploy.js`

## Upgrade

- modify address in `scripts/upgrade`
- `npx hardhat run --network mumba scripts/upgrade.js`
