// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
// Local
import {DNFT} from "contracts/DNFT.sol";
import {DeployDNFT} from "script/DeployDNFT.s.sol";

contract TestDNFT is Test {
    string TOKEN_URI = "ipfs://test-uri";

    DNFT dnft;

    address user = address("user");

    function setUp() public {
        //DeployDNFT deployer = new DeployDNFT();
        //deployer.run();
        dnft = new DNFT(address(this));
        console2.log("Workie");
    }

    function testMint() public {
        dnft.mintNFT(user, "ipfs://test-uri");
        assertEq(dnft.ownerOf(0), address(0x123), "Owner should be correct");
    }

    function testTokenIdIncrements() public {
        // Mint the first NFT
        string memory tokenURI = TOKEN_URI;
        dnft.mintNFT(user, tokenURI);
    }

    function testCanApproveMarketplace() public {}
}
