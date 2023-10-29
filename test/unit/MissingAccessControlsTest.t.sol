// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {MissingAccessControls} from "../../src/missing-access-controls/MissingAccessControls.sol";

contract MissingAccessControlsTest is Test {
    MissingAccessControls public missingAccessControls;

    function setUp() public {
        missingAccessControls = new MissingAccessControls();
    }

    function test_anyoneCanSetOwner(address randomOwner) public {
        missingAccessControls.setOwner(randomOwner);
        assertEq(missingAccessControls.owner(), randomOwner);
    }
}
