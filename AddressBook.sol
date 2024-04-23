// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title AddressBook
 * @dev Manages a list of contacts in a secure and structured manner. Provides functionality to add, delete, and view contacts.
 */
contract AddressBook is Ownable(msg.sender) {
    struct Contact {
        uint id;
        string firstName;
        string lastName;
        uint[] phoneNumbers;
    }

    Contact[] private contacts; // Dynamic array to store contacts.
    mapping(uint => uint) private idToIndex; // Maps a contact's ID to its index in the array.
    uint private nextId = 1; // Tracks the ID for the next contact to ensure uniqueness.

    error ContactNotFound(uint id); // Custom error for non-existent contacts.

    /**
     * @notice Adds a new contact to the address book.
     * @param firstName The first name of the contact.
     * @param lastName The last name of the contact.
     * @param phoneNumbers An array of phone numbers associated with the contact.
     */
    function addContact(string calldata firstName, string calldata lastName, uint[] calldata phoneNumbers) external onlyOwner {
        contacts.push(Contact(nextId, firstName, lastName, phoneNumbers));
        idToIndex[nextId] = contacts.length - 1;
        nextId++;
    }

    /**
     * @notice Deletes a contact from the address book by ID.
     * @param id The unique identifier of the contact to delete.
     */
    function deleteContact(uint id) external onlyOwner {
        uint index = idToIndex[id];
        if (index >= contacts.length || contacts[index].id != id) {
            revert ContactNotFound(id);
        }

        // Move the last contact to the deleted position and update mappings
        contacts[index] = contacts[contacts.length - 1];
        idToIndex[contacts[index].id] = index;
        contacts.pop();
        delete idToIndex[id];
    }

    /**
     * @notice Retrieves a contact by ID.
     * @param id The unique identifier of the contact.
     * @return The contact corresponding to the ID.
     */
    function getContact(uint id) external view returns (Contact memory) {
        uint index = idToIndex[id];
        if (index >= contacts.length || contacts[index].id != id) {
            revert ContactNotFound(id);
        }
        return contacts[index];
    }

    /**
     * @notice Retrieves all contacts.
     * @return An array of all active contacts.
     */
    function getAllContacts() external view returns (Contact[] memory) {
        return contacts;
    }
}
