// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract MissingAccessControls {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    /* 
     * @notice Set the owner of the contract
     * @notice This should only be callable by the current owner
     * @param newOwner The address of the new owner
     */
    function setOwner(address newOwner) external {
        // This is missing a check on whether the caller is the current owner!!
        owner = newOwner;
    }
}
