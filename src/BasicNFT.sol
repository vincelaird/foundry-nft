// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

/// @title BasicNFT
/// @author Vince Laird
/// @notice A simple NFT contract for minting and managing dog-themed tokens
/// @dev Extends OpenZeppelin's ERC721 implementation
contract BasicNFT is ERC721 {
    uint256 private s_tokenCounter;
    mapping(uint256 => string) private s_tokenIdToURI;

    /// @notice Initializes the contract with the name "Doggy" and symbol "DOG"
    constructor() ERC721("Doggy", "DOG") {
        s_tokenCounter = 0;
    }

    /// @notice Mints a new NFT with the given token URI
    /// @param tokenUri The URI containing the metadata for the new token
    /// @dev Increments the token counter after minting
    function mintNFT(string memory tokenUri) public {
        uint256 newTokenId = s_tokenCounter;
        s_tokenIdToURI[newTokenId] = tokenUri;
        _safeMint(msg.sender, newTokenId);
        s_tokenCounter++;
        emit Transfer(address(0), msg.sender, newTokenId);
    }

    /// @notice Returns the URI for a given token ID
    /// @param tokenId The ID of the token to query
    /// @return The URI string associated with the given token ID
    /// @dev Overrides the tokenURI function from ERC721
    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        return s_tokenIdToURI[tokenId];
    }

    // Getters
    function getTokenCounter() public view returns (uint256) {
        return s_tokenCounter;
    }
}
