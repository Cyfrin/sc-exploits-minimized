// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test} from "forge-std/Test.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";
import {StatefulFuzzCatches} from "../../src/invariant-break/StatefulFuzzCatches.sol";

contract StatefulFuzzCatchesTest is StdInvariant, Test {
    StatefulFuzzCatches public sfc;

    function setUp() public {
        sfc = new StatefulFuzzCatches();
        targetContract(address(sfc));
    }

    // Stateless fuzz, doesn't work
    function testFuzzPassesEasyInvariant(uint128 randomNumber) public {
        sfc.doMoreMathAgain(randomNumber);
        assert(sfc.storedValue() != 0);
    }

    // // Stateful fuzz
    // // also can use the prefix `invariant_`
    // // Uncomment this to see it catch the issue!
    function statefulFuzz_testMathDoesntReturnZero() public view {
        assert(sfc.storedValue() != 0);
    }
}
