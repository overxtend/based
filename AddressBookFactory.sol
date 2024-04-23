// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./AddressBook.sol";

/**
 * @title AddressBookFactory
 * @dev Factory for creating and deploying instances of AddressBook contracts.
 */
contract AddressBookFactory {
    /**
     * @notice Deploys a new AddressBook and transfers ownership to the caller.
     * @return address The address of the newly created AddressBook contract.
     */
    function deploy() public returns (address) {
        AddressBook newAddressBook = new AddressBook();
        newAddressBook.transferOwnership(msg.sender);
        return address(newAddressBook);
    }
}
