// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";

/**
 * @title Haiku NFT Contract
 * @dev Implements an ERC721 token to represent ownership of haikus.
 */
contract HaikuNFT is ERC721 {
    // Structure to represent a Haiku poem
    struct Haiku {
        address author;
        string line1;
        string line2;
        string line3;
    }

    // Array to store all Haikus
    Haiku[] public haikus;
    
    // Mapping to track which Haikus have been shared with which addresses
    mapping(address => mapping(uint256 => bool)) public sharedHaikus;
    
    // Counter to keep track of the number of Haikus minted
    uint256 public haikuCounter;

    // Constructor to set up the ERC721 token with a name and symbol
    constructor() ERC721("HaikuNFT", "HAIKU") {
        haikuCounter = 1; // Ensures that the first Haiku has an ID of 1
    }

    /**
     * @dev Returns the total number of haikus minted.
     */
    function counter() external view returns (uint256) {
        return haikuCounter;
    }

    /**
     * @dev Mints a new Haiku NFT if the haiku is unique.
     * Reverts with HaikuNotUnique if any line of the haiku has been used before in any haiku.
     * @param _line1 First line of the haiku.
     * @param _line2 Second line of the haiku.
     * @param _line3 Third line of the haiku.
     */
    function mintHaiku(
        string memory _line1,
        string memory _line2,
        string memory _line3
    ) external {
        ensureHaikuUniqueness(_line1, _line2, _line3);
        _safeMint(msg.sender, haikuCounter);
        haikus.push(Haiku(msg.sender, _line1, _line2, _line3));
        haikuCounter++;
    }

    /**
     * @dev Shares a Haiku NFT with another user.
     * Reverts with NotYourHaiku if the caller is not the haiku's author.
     * @param _id ID of the haiku to share.
     * @param _to Address of the recipient to share the haiku with.
     */
    function shareHaiku(uint256 _id, address _to) external {
        require(_id > 0 && _id < haikuCounter, "Invalid haiku ID");
        require(haikus[_id - 1].author == msg.sender, "NotYourHaiku");
        sharedHaikus[_to][_id] = true;
    }

    /**
     * @dev Retrieves all haikus shared with the caller's address.
     * Reverts with NoHaikusShared if no haikus have been shared with the caller.
     */
    function getMySharedHaikus() external view returns (Haiku[] memory) {
        uint256 sharedHaikuCount = 0;
        for (uint256 i = 0; i < haikuCounter; i++) {
            if (sharedHaikus[msg.sender][i]) {
                sharedHaikuCount++;
            }
        }

        if (sharedHaikuCount == 0) {
            revert NoHaikusShared();
        }

        Haiku[] memory result = new Haiku[](sharedHaikuCount);
        uint256 currentIndex = 0;
        for (uint256 i = 0; i < haikuCounter; i++) {
            if (sharedHaikus[msg.sender][i]) {
                result[currentIndex] = haikus[i - 1];
                currentIndex++;
            }
        }
        return result;
    }

    /**
     * @dev Ensures that each line of a new haiku is unique across all haikus.
     * @param _line1 First line of the new haiku.
     * @param _line2 Second line of the new haiku.
     * @param _line3 Third line of the new haiku.
     */
    function ensureHaikuUniqueness(string memory _line1, string memory _line2, string memory _line3) internal view {
        for (uint256 i = 0; i < haikus.length; i++) {
            Haiku storage haiku = haikus[i];
            if (compareStrings(haiku.line1, _line1) || compareStrings(haiku.line2, _line2) || compareStrings(haiku.line3, _line3)) {
                revert HaikuNotUnique();
            }
        }
    }

    /**
     * @dev Compares two strings for equality.
     * @param a First string.
     * @param b Second string.
     * @return True if the strings are equal, false otherwise.
     */
    function compareStrings(string memory a, string memory b) internal pure returns (bool) {
        return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
    }

    // Custom errors
    error HaikuNotUnique(); // Error thrown when attempting to mint a non-unique haiku
    error NotYourHaiku(); // Error thrown when attempting to share a haiku not owned by the caller
    error NoHaikusShared(); // Error thrown when no haikus have been shared with the caller
}
