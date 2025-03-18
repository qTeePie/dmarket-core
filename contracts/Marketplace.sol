// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract Marketplace is ReentrancyGuard {
    struct Listing {
        address seller;
        address nftContract;
        uint256 tokenId;
        uint256 price;
        bool active;
    }

    mapping(uint256 => Listing) public listings;
    uint256 private _listingId;

    event NFTListed(
        uint256 indexed listingId, address indexed seller, address nftContract, uint256 tokenId, uint256 price
    );

    function listNFT(address nftContract, uint256 tokenId, uint256 price) external {
        IERC721 nft = IERC721(nftContract);
        require(nft.ownerOf(tokenId) == msg.sender, "Not your NFT");
        require(nft.getApproved(tokenId) == address(this), "Marketplace not approved");

        listings[_listingId] = Listing(msg.sender, nftContract, tokenId, price, true);
        emit NFTListed(_listingId, msg.sender, nftContract, tokenId, price);

        _listingId++;
    }

    function getAllListings() external view returns (Listing[] memory) {
        uint256 count = _listingId;
        Listing[] memory activeListings = new Listing[](count);

        for (uint256 i = 0; i < count; i++) {
            if (listings[i].active) {
                activeListings[i] = listings[i];
            }
        }
        return activeListings;
    }
}
