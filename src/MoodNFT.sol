// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

/// @title MoodNFT
/// @author Vince Laird
/// @notice This contract implements a mood-based NFT that can be minted and have its mood flipped
/// @dev Inherits from OpenZeppelin's ERC721 contract
contract MoodNFT is ERC721 {
    // errors
    error MoodNFT__CannotFlipMoodIfNotOwner();
    error MoodNFT__TokenDoesNotExist();
    // only the NFT owner can flip the mood
    uint256 private s_tokenCounter;
    string private s_sadSVGImageURI;
    string private s_happySVGImageURI;

    enum Mood {
        HAPPY,
        SAD
    }

    mapping(uint256 => Mood) private s_tokenIdToMood;

    /// @notice Constructor to initialize the MoodNFT contract
    /// @param sadSVGImageURI The URI for the sad mood SVG image
    /// @param happySVGImageURI The URI for the happy mood SVG image
    constructor(
        string memory sadSVGImageURI,
        string memory happySVGImageURI
    ) ERC721("MoodNFT", "MOOD") {
        s_sadSVGImageURI = sadSVGImageURI;
        s_happySVGImageURI = happySVGImageURI;
        s_tokenCounter = 0;
    }

    /// @notice Mints a new MoodNFT
    /// @dev Mints a new token and sets its initial mood to HAPPY
    function mintNFT() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIdToMood[s_tokenCounter] = Mood.HAPPY;
        s_tokenCounter++;
    }

    /// @notice Flips the mood of a specific token
    /// @dev Only the owner or approved addresses can flip the mood
    /// @param tokenId The ID of the token to flip the mood
    function flipMood(uint256 tokenId) public {
        if (
            ownerOf(tokenId) != msg.sender &&
            getApproved(tokenId) != msg.sender &&
            !isApprovedForAll(ownerOf(tokenId), msg.sender)
        ) {
            revert MoodNFT__CannotFlipMoodIfNotOwner();
        }

        if (s_tokenIdToMood[tokenId] == Mood.HAPPY) {
            s_tokenIdToMood[tokenId] = Mood.SAD;
        } else {
            s_tokenIdToMood[tokenId] = Mood.HAPPY;
        }
    }

    /// @notice Returns the base URI for computing {tokenURI}
    /// @return The base URI string
    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    /// @notice Returns the URI for a given token ID
    /// @dev Throws if the token ID does not exist
    /// @param tokenId The ID of the token to query
    /// @return The token URI string
    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        if (_ownerOf(tokenId) == address(0)) {
            revert MoodNFT__TokenDoesNotExist();
        }

        string memory imageURI;
        if (s_tokenIdToMood[tokenId] == Mood.HAPPY) {
            imageURI = s_happySVGImageURI;
        } else {
            imageURI = s_sadSVGImageURI;
        }

        return
            string(
                abi.encodePacked(
                    _baseURI(),
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name": "',
                                name(),
                                '", "description": "An NFT that represents your mood", "attributes": [{"trait_type": "moodiness", "value": 100}], "image": "',
                                imageURI,
                                '"}'
                            )
                        )
                    )
                )
            );
    }

    // Getters

    /// @notice Returns the URI of the sad SVG image
    /// @return The sad SVG image URI
    function getSadSVGImageURI() public view returns (string memory) {
        return s_sadSVGImageURI;
    }

    /// @notice Returns the URI of the happy SVG image
    /// @return The happy SVG image URI
    function getHappySVGImageURI() public view returns (string memory) {
        return s_happySVGImageURI;
    }

    /// @notice Returns the current token counter
    /// @return The current token counter value
    function getTokenCounter() public view returns (uint256) {
        return s_tokenCounter;
    }

    /// @notice Returns the mood of a specific token
    /// @param tokenId The ID of the token to query
    /// @return The mood of the specified token
    function getMood(uint256 tokenId) public view returns (Mood) {
        return s_tokenIdToMood[tokenId];
    }
}
