// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import {DNFT} from "contracts/DNFT.sol";
import {DMarket} from "contracts/DMarket.sol";

contract TestDMarketplace is Test {
    string constant TOKEN_URI = "ipfs://test-uri";

    address immutable user = makeAddr("user");
    DNFT dnft;
    DMarket marketplace;

    function setUp() public {
        dnft = new DNFT();
        marketplace = new DMarket();
    }

    function testCanListNFT() public {
        // Mint to user
        vm.prank(user);
        dnft.mintNFT(user, TOKEN_URI);

        // Approve the marketplace
        vm.prank(user);
        dnft.approve(address(marketplace), 0);

        // List the NFT
        vm.prank(user);
        marketplace.listNFT(address(dnft), 0, 1 ether);

        // Check listing was stored
        (address seller, address nftAddr, uint256 tokenId, uint256 price, bool active) = marketplace.listings(0);

        assertEq(seller, user, "Seller should match");
        assertEq(nftAddr, address(dnft), "NFT contract address should match");
        assertEq(tokenId, 0, "Token ID should match");
        assertEq(price, 1 ether, "Price should match");
        assertEq(active, true, "Listing should be active");
    }
}
