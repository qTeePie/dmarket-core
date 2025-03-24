# 🐱‍👤 DNFT + Mainnet Fork Project

This is a small project where I deployed and tested an NFT smart contract (**DNFT**) using [Foundry](https://book.getfoundry.sh/) and a forked Ethereum mainnet with [Anvil](https://book.getfoundry.sh/anvil/). Not a full app — just a practical setup while I’m learning smart contract workflows. 💫

---

## 📦 What’s Included

- `contracts/DNFT.sol` – simple ERC721 NFT contract
- `script/DeployDNFT.s.sol` – deploy script to forked mainnet + mint
- `test/` – basic WIP tests

---

## 🎯 Purpose

I wanted to:

- Learn how to deploy contracts to a forked mainnet
- Simulate real Ethereum interactions (no gas)
- Mint and verify NFTs directly from the terminal 🧪

This repo is public to show my learning process and progress.  
I’m currently working toward becoming a full-time Web3 developer. 🚀

---

## 📝 Step-by-Step Guide

I wrote a guide to help myself (and maybe someone else) through this whole process:

👉 [`docs/forked-mainnet-dnft-guide.md`](docs/forked-mainnet-dnft-guide.md)

---

## ⚙️ Tech Stack

- Solidity `^0.8.20`
- Foundry (forge, cast, anvil)
- Alchemy (for RPC fork)
- IPFS (for tokenURI)

---

## 🧠 Notes

This repo is a work in progress.  
It’s part of my learning journey with realistic smart contract testing using Foundry and mainnet forking.

---

## 💙 About Me

I'm learning blockchain dev with a focus on NFTs, smart contract security, and creator-first tools.  
This is one of many steps toward that goal.

---

## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

- **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
- **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
- **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
- **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
