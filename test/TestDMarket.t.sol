// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "forge-std/console2.sol";
import {MockNFT} from "test/mocks/ERC721Mock.sol";
import {DMarket} from "contracts/DMarket.sol";

contract TestDMarketplace is Test {
    string constant TOKEN_URI = "ipfs://test-uri";

    address immutable user = makeAddr("user");
    MockNFT nft;
    DMarket marketplace;

    function setUp() public {
        nft = new MockNFT();
        marketplace = new DMarket();
    }

    /*
        Security Test: Prevent duplicate active listings
        This test ensures that an NFT cannot be listed multiple times without being sold or delisted first.
        Prevents potential attack vectors, stale data, and unnecessary state bloat.
    */

    function testNoDuplicateListings() public {
        mintAndApprove(user, 0);
        // List NFT
        vm.prank(user);
        marketplace.listNFT(address(nft), 0, 1); // List NFT again
        vm.prank(user);

        vm.expectRevert("Listing already exists");
        marketplace.listNFT(address(nft), 0, 1);
    }

    function testCanListNFT() public {
        mintAndApprove(user, 0);

        // List the NFT
        vm.prank(user);
        marketplace.listNFT(address(nft), 0, 1 ether);

        // Check listing was stored
        (address seller, address nftAddr, uint256 tokenId, uint256 price, bool active) = marketplace.listings(0);

        assertEq(seller, user, "Seller should match");
        assertEq(nftAddr, address(nft), "NFT contract address should match");
        assertEq(tokenId, 0, "Token ID should match");
        assertEq(price, 1 ether, "Price should match");
        assertEq(active, true, "Listing should be active");
    }

    function mintAndApprove(address to, uint256 tokenId) private {
        // Mint to user
        vm.startPrank(to);
        nft.mint(to);

        // ApproveMarketplace
        nft.approve(address(marketplace), tokenId);
        vm.stopPrank();
    }
}
