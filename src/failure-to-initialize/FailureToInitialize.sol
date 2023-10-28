// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract FailureToInitialize {
    uint256 public myValue;
    bool public initialized;

    function initialize(uint256 _startingValue) public {
        myValue = _startingValue;
        initialized = true;
    }

    // We should have a check here to make sure the contract was initialized!
    function increment() public {
        myValue++;
    }
}
