// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
// Local
import {DNFT} from "contracts/DNFT.sol";
import {DeployDNFT} from "script/DeployDNFT.s.sol";

contract TestDNFT is Test {
    DNFT dnft;

    function setUp() public {
        DeployDNFT deployer = new DeployDNFT();
        dnft = new DNFT(address(this));
        console2.log("Workie");
    }

    function testMint() public {
        dnft.mintNFT(address(0x123), "ipfs://test-uri");
        assertEq(dnft.ownerOf(0), address(0x123), "Owner should be correct");
    }

    function testCanApproveMarketplace() public {}
}
