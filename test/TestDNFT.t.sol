// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
// Local
import {DNFT} from "contracts/DNFT.sol";
import {DeployDNFT} from "script/DeployDNFT.s.sol";

contract TestDNFT is Test {
    string constant TOKEN_URI = "ipfs://test-uri";

    address immutable user = makeAddr("user");
    address immutable marketplace = makeAddr("marketplace");

    DNFT dnft;

    function setUp() public {
        //DeployDNFT deployer = new DeployDNFT();
        //deployer.run();

        // Initialize DNFT
        dnft = new DNFT();
        console2.log("Workie");
    }

    function testMint() public {
        // Arrange Act
        dnft.mintNFT(user, "ipfs://test-uri");

        // Assert
        assertEq(dnft.ownerOf(0), user, "Owner should be correct");
    }

    function testCanApproveMarketplace() public {
        // Arrange
        dnft.mintNFT(user, TOKEN_URI);
        vm.prank(user);

        // Act
        dnft.approveMarketplace(marketplace, 0);
        assertEq(dnft.getApproved(0), marketplace);
    }
}
