// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {DoS} from "../../src/denial-of-service/DoS.sol";

contract DoSTest is Test {
    DoS public dos;

    address warmUpAddress = makeAddr("warmUp");
    address personA = makeAddr("A");
    address personB = makeAddr("B");
    address personC = makeAddr("C");

    function setUp() public {
        dos = new DoS();
    }

    function test_denialOfService() public {
        // We want to warm up the storage stuff
        vm.prank(warmUpAddress);
        dos.enter();

        uint256 gasStartA = gasleft();
        vm.prank(personA);
        dos.enter();
        uint256 gasCostA = gasStartA - gasleft();

        uint256 gasStartB = gasleft();
        vm.prank(personB);
        dos.enter();
        uint256 gasCostB = gasStartB - gasleft();

        uint256 gasStartC = gasleft();
        vm.prank(personC);
        dos.enter();
        uint256 gasCostC = gasStartC - gasleft();

        console2.log("Gas cost A: %s", gasCostA);
        console2.log("Gas cost B: %s", gasCostB);
        console2.log("Gas cost C: %s", gasCostC);

        // The gas cost will just keep rising, making it harder and harder for new people to enter!
        assert(gasCostC > gasCostB);
        assert(gasCostB > gasCostA);
    }
}
