// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SimpleNFT is ERC721URIStorage, Ownable {
    uint256 private _nextTokenId;

    constructor() ERC721("SimpleNFT", "SNFT") Ownable(msg.sender) {}

    function mintNFT(address to, string memory tokenURI) external onlyOwner {
        uint256 tokenId = _nextTokenId;
        _nextTokenId++;
        _mint(to, tokenId);
        _setTokenURI(tokenId, tokenURI);
    }

    function approveMarketplace(address marketplace, uint256 tokenId) external {
        require(ownerOf(tokenId) == msg.sender, "Not your NFT");
        approve(marketplace, tokenId);
    }
}
