// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {FormalVerificationCatches} from "../../../../../src/invariant-break/FormalVerificationCatches.sol";

contract FVCatchesHarness {
    FormalVerificationCatches public fvc;

    constructor() {
        fvc = new FormalVerificationCatches();
    }

    function tryCatchHellFunc(uint128 number) public view returns (bool) {
        try fvc.hellFunc(number) returns (uint256) {
            return true;
        } catch {
            return false;
        }
    }
}
