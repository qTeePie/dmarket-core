# Survival Guide: Deploying & Minting DNFT on a Mainnet Fork 💙🐱‍💄

## 🚀 GOAL

Deploy your DNFT contract to a forked Ethereum mainnet using Anvil + Foundry, mint an NFT, and verify it's minted — all from terminal. No dying allowed. 😭

---

## 💻 PREREQUISITES

- Installed: [Foundry (forge, cast)](https://book.getfoundry.sh/getting-started/installation)
- Installed: [Anvil (comes with Foundry)]
- An [Alchemy API key](https://dashboard.alchemy.com/)
- Your DNFT contract and `DeployDNFT.s.sol` script ready

---

## 🌪️ STEP 1: Start Your Forked Mainnet with Anvil

```bash
anvil --fork-url https://eth-mainnet.g.alchemy.com/v2/YOUR_KEY --chain-id 1111
```

Expected output:

- Starts listening on `127.0.0.1:8545`
- Gives you rich test accounts + private keys

✅ Copy the private key of Account (0): 0xac09...
✅ You’ll use it to deploy your contract

---

## 📁 STEP 2: Set Up foundry.toml

Make sure you have this in your `foundry.toml`:

```toml
[rpc_endpoints]
anvilFork = "http://127.0.0.1:8545"
```

---

## 🧙 STEP 3: Run Your Deploy Script

Example script: `script/DeployDNFT.s.sol`

```solidity
contract DeployDNFT is Script {
    function run() external {
        vm.startBroadcast();
        DNFT nft = new DNFT();
        console.log("Deployed DNFT at:", address(nft));
        nft.mintNFT(YOUR_ADDRESS, "ipfs://your-uri");
        vm.stopBroadcast();
    }
}
```

Deploy it:

```bash
forge script script/DeployDNFT.s.sol:DeployDNFT \
  --rpc-url anvilFork \
  --private-key 0xac0974... \
  --broadcast
```

✅ Note the output contract address (`0xABC...`) — this is your DNFT contract!

---

## 🔍 STEP 4: Verify Mint from Terminal (NO METAMASK)

### 🔎 Check ownerOf(tokenId)

```bash
cast call 0xYourContractAddress "ownerOf(uint256)" 0 \
  --rpc-url http://127.0.0.1:8545
```

Should return:

```
0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
```

### 🔎 Check tokenURI

```bash
cast call 0xYourContractAddress "tokenURI(uint256)" 0 \
  --rpc-url http://127.0.0.1:8545
```

Returns your IPFS URI.

---

## 🧼 If It Breaks (aka Foundry Gremlins)

- Run `forge clean`
- Then run `forge build`
- Then re-run your deploy script

---

## 👑 You Did It

You now know how to:

- Fork mainnet
- Deploy contracts to it
- Mint NFTs
- Verify everything from terminal

You’re not just learning — you’re leveling up into a **real on-chain dev warrior**.
