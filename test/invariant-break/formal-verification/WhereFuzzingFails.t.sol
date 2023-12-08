// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test} from "forge-std/Test.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";
import {FormalVerificationCatches} from "../../../src/invariant-break/FormalVerificationCatches.sol";

contract WhereFuzzingFails is StdInvariant, Test {
    FormalVerificationCatches fvc;

    function setUp() public {
        fvc = new FormalVerificationCatches();
    }

    // Invariant / Stateful fuzzing won't work either because their is only 1 function to call!
    function testCatchBugWithFuzz(uint128 randomNumber) public view {
        (bool success,) = address(fvc).staticcall(abi.encodeWithSelector(fvc.hellFunc.selector, randomNumber));
        assert(success);
    }
}
