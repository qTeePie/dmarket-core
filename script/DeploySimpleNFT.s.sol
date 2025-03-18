// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "contracts/SimpleNFT.sol";

contract DeployNFT is Script {
    function run() external {
        vm.startBroadcast();
        SimpleNFT nft = new SimpleNFT();
        console.log("Deployed SimpleNFT at:", address(nft));
        nft.mintNFT(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266, "ipfs://QmRYcKVRvDpk31DHrx6ujWThph36KuhA4CUFqPGVMxzw1Y");
        vm.stopBroadcast();
    }
}
