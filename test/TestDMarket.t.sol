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

    function testNoDuplicateListings() public {
        uint256 tokenId = mintAndApprove(user);
        listNFT(user, tokenId, 1);

        vm.prank(user);
        vm.expectRevert("Listing already exists");
        marketplace.listNFT(address(nft), tokenId, 1);
    }

    function testCanListNFT() public {
        uint256 tokenId = mintAndApprove(user);
        uint256 listingId = listNFT(user, tokenId, 1 ether);

        (address seller, address nftAddr, uint256 listedTokenId, uint256 price, bool active) =
            marketplace.listings(listingId);

        assertEq(seller, user, "Seller should match");
        assertEq(nftAddr, address(nft), "NFT contract address should match");
        assertEq(listedTokenId, tokenId, "Token ID should match");
        assertEq(price, 1 ether, "Price should match");
        assertEq(active, true, "Listing should be active");
    }

    function testBuyNFT() public {
        address buyer = makeAddr("buyer");
        uint256 price = 1 ether;

        (uint256 tokenId, uint256 listingId) = mintAndList(user, price);

        vm.deal(buyer, price * 2);

        vm.expectEmit(true, true, false, false, address(marketplace));
        emit DMarket.NFTBought(listingId, buyer, price);

        vm.prank(buyer);
        marketplace.buyNFT{value: price}(listingId);

        assertEq(marketplace.listingCounter(), listingId + 1, "Listing counter should increment");
        assertEq(marketplace.isListed(address(nft), tokenId, user), false, "Listing should be removed");
        assertEq(nft.ownerOf(tokenId), buyer, "Ownership should be transferred");
    }

    function testDelistNFT() public {
        (uint256 tokenId, uint256 listingId) = mintAndList(user, 1 ether);

        vm.prank(user);
        marketplace.delistNFT(listingId);

        assertEq(marketplace.listingCounter(), listingId + 1, "Listing should increment");
        assertEq(marketplace.isListed(address(nft), tokenId, user), false, "Listing should be removed");
    }

    function testDelistNFTRevertsIfNotSeller() public {
        (uint256 tokenId, uint256 listingId) = mintAndList(user, 1 ether);

        address otherUser = makeAddr("other");
        vm.prank(otherUser);
        vm.expectRevert("Not your listing");
        marketplace.delistNFT(listingId);
    }

    function testQuickBuyFlow() public {
        address buyer = makeAddr("buyer");
        (uint256 tokenId,) = mintListBuy(user, buyer, 1 ether);

        assertEq(nft.ownerOf(tokenId), buyer, "Ownership should be transferred");
    }

    // -----------------------
    // 🔧 PRIVATE HELPERS BELOW
    // -----------------------

    function mintAndApprove(address to) private returns (uint256 tokenId) {
        tokenId = nft.nextTokenId();
        vm.startPrank(to);
        nft.mint(to);
        nft.approve(address(marketplace), tokenId);
        vm.stopPrank();
    }

    function listNFT(address seller, uint256 tokenId, uint256 price) private returns (uint256 listingId) {
        listingId = marketplace.listingCounter();
        vm.prank(seller);
        marketplace.listNFT(address(nft), tokenId, price);
    }

    function mintAndList(address seller, uint256 price) private returns (uint256 tokenId, uint256 listingId) {
        tokenId = mintAndApprove(seller);
        listingId = listNFT(seller, tokenId, price);
    }

    function mintListBuy(address seller, address buyer, uint256 price)
        private
        returns (uint256 tokenId, uint256 listingId)
    {
        (tokenId, listingId) = mintAndList(seller, price);
        vm.deal(buyer, price);
        vm.prank(buyer);
        marketplace.buyNFT{value: price}(listingId);
    }
}
