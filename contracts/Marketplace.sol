// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTMarketplace is Ownable {
    struct Listing {
        address seller;
        address nftContract;
        uint256 tokenId;
        uint256 price;
        bool active;
    }

    mapping(uint256 => Listing) public listings;
    uint256 public listingCounter;

    event NFTListed(
        uint256 indexed listingId, address indexed seller, address nftContract, uint256 tokenId, uint256 price
    );
    event NFTBought(uint256 indexed listingId, address indexed buyer, uint256 price);
    event NFTDelisted(uint256 indexed listingId);

    constructor() Ownable(msg.sender) {} // Sets deployer as the owner

    function listNFT(address nftContract, uint256 tokenId, uint256 price) external {
        IERC721 nft = IERC721(nftContract);
        require(nft.ownerOf(tokenId) == msg.sender, "Not your NFT");
        require(nft.getApproved(tokenId) == address(this), "Marketplace not approved");

        listings[listingCounter] = Listing(msg.sender, nftContract, tokenId, price, true);
        emit NFTListed(listingCounter, msg.sender, nftContract, tokenId, price);
        listingCounter++;
    }

    function buyNFT(uint256 listingId) external payable {
        Listing storage listing = listings[listingId];
        require(listing.active, "NFT not listed");
        require(msg.value == listing.price, "Incorrect price");

        listing.active = false;
        payable(listing.seller).transfer(msg.value);
        IERC721(listing.nftContract).safeTransferFrom(listing.seller, msg.sender, listing.tokenId);

        emit NFTBought(listingId, msg.sender, listing.price);
    }

    function delistNFT(uint256 listingId) external {
        Listing storage listing = listings[listingId];
        require(listing.seller == msg.sender, "Not your listing");
        require(listing.active, "Already delisted");

        listing.active = false;
        emit NFTDelisted(listingId);
    }
}
