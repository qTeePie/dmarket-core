// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "contracts/SimpleNFT.sol";

contract DeployNFT is Script {
    function run() external {
        vm.startBroadcast();
        SimpleNFT nft = new SimpleNFT();
        console.log("Deployed SimpleNFT at:", address(nft));

        vm.stopBroadcast();
    }
}
