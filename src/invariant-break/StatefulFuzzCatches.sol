// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

// INVARIANT: doMoreMathAgain should never return 0
contract StatefulFuzzCatches {
    uint256 public myValue = 1;
    uint256 public storedValue = 100;

    /*
     * @dev Should never return 0
     */
    function doMoreMathAgain(uint128 myNumber) public returns (uint256) {
        uint256 response = (uint256(myNumber) / 1) + myValue;
        storedValue = response;
        return response;
    }

    function changeValue(uint256 newValue) public {
        myValue = newValue;
    }
}
