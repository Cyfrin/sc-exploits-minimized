// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {WeakRandomness} from "../../src/weak-randomness/WeakRandomness.sol";

contract WeakRandomnessTest is Test {
    WeakRandomness public weakRandomness;

    function setUp() public {
        weakRandomness = new WeakRandomness();
    }

    // For this test, a user could just deploy a contract that guesses the random number...
    // by calling the random number in the same block!!
    function test_guessRandomNumber() public {
        uint256 randomNumber = weakRandomness.getRandomNumber();

        assertEq(randomNumber, weakRandomness.getRandomNumber());
    }
}
