// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DMarket is Ownable {
    struct Listing {
        address seller;
        address nftContract;
        uint256 tokenId;
        uint256 price;
        bool active;
    }

    mapping(uint256 => Listing) public listings;
    uint256 public listingCounter;

    /**
     * Listing Tracking Logic 📝
     *
     * I'm using this mapping to make sure a seller can’t list the same NFT twice without delisting it first:
     * mapping(address => mapping(uint256 => mapping(address => bool))) isListed;
     * → It tracks: [nftContract][tokenId][seller]
     *
     * Why I added it:
     * ✅ Stops sellers from spamming the same NFT multiple times
     * ✅ Lets new owners list the NFT after it’s sold or transferred
     * ✅ Keeps things simple and easy to follow
     *
     * ⚠️ Things I know aren’t perfect:
     * - If the seller transfers their NFT without delisting → this flag will stay "true" (I can’t auto-clean it)
     * - Costs extra gas to store this
     * - It’s not scalable for big marketplaces but fine for small ones & learning
     *
     * I wanted to prevent duplicate listings without making this a huge protocol project.
     * This is the easiest way to learn safe on-chain state management without over-engineering.
     *
     * Bigger protocols now use off-chain signatures for listings (like Seaport) to avoid problems like this,
     * but I’m building this approval-based version on purpose to understand how on-chain state works.
     */
    mapping(address => mapping(uint256 => mapping(address => bool))) public isListed;

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

        // Check if listing already exists
        require(!isListed[nftContract][tokenId][msg.sender], "Listing already exists");

        // Listing doesn't exist => create listing
        listings[listingCounter] = Listing(msg.sender, nftContract, tokenId, price, true);
        isListed[nftContract][tokenId][msg.sender] = true;

        emit NFTListed(listingCounter, msg.sender, nftContract, tokenId, price);

        listingCounter++;
    }

    function buyNFT(uint256 listingId) external payable {
        Listing storage listing = listings[listingId];
        require(listing.active, "NFT not listed");
        require(msg.value == listing.price, "Incorrect price");

        listing.active = false;
        isListed[listing.nftContract][listing.tokenId][listing.seller] = false;

        payable(listing.seller).transfer(msg.value);
        IERC721(listing.nftContract).safeTransferFrom(listing.seller, msg.sender, listing.tokenId);

        emit NFTBought(listingId, msg.sender, listing.price);
    }

    function delistNFT(uint256 listingId) external {
        Listing storage listing = listings[listingId];
        require(listing.seller == msg.sender, "Not your listing");
        require(listing.active, "Already delisted");

        listing.active = false;
        isListed[listing.nftContract][listing.tokenId][listing.seller] = false;

        emit NFTDelisted(listingId);
    }
}
