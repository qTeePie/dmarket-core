// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import {DMarket} from "contracts/DMarket.sol";

contract DeployDMarket is Script {
    function run() external {
        vm.startBroadcast();

        DMarket market = new DMarket();
        console.log("DMarket deployed at:", address(market));

        vm.stopBroadcast();
    }
}
