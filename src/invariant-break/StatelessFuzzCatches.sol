// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

// INVARIANT: doMath should never return 0
contract StatelessFuzzCatches {
    /*
     * @dev Should never return 0
     */
    function doMath(uint128 myNumber) public pure returns (uint256) {
        if (myNumber == 2) {
            return 0;
        }
        return 1;
    }
}
