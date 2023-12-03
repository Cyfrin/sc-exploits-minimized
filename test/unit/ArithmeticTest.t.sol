// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {Overflow, Underflow, PrecisionLoss} from "../../src/arithmetic/OverflowAndUnderflow.sol";

contract ArithmeticTest is Test {
    Overflow public overflow;
    Underflow public underflow;
    PrecisionLoss public precisionLoss;

    function setUp() public {
        overflow = new Overflow();
        underflow = new Underflow();
        precisionLoss = new PrecisionLoss();
    }

    function test_overflow() public {
        uint8 amount = type(uint8).max;
        overflow.increment(amount);
        overflow.increment(1);

        // Wait... it's zero??
        assertEq(overflow.count(), 0);
    }

    function test_underflow() public {
        uint256 count = uint256(underflow.count());
        uint256 timesToDecrement = count + 1;

        for (uint256 i = 0; i < timesToDecrement; i++) {
            underflow.decrement();
        }

        // Wait... it's 255??
        assertEq(underflow.count(), 255);
    }

    function test_precisionLoss() public {
        // we lost 0.25 monies :(
        assertEq(precisionLoss.shareMoney(), 56);
    }
}
