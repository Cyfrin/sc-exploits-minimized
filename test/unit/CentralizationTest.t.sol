// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {Centralization} from "../../src/centralization/Centralization.sol";

contract CentralizationTest is Test {
    Centralization public centralization;
    address public user = makeAddr("user");
    address public owner = makeAddr("owner");
    uint256 amount = 1 ether;

    function setUp() public {
        vm.startPrank(owner);
        centralization = new Centralization();
        vm.stopPrank();
        vm.deal(user, amount);
    }

    function testSetUpCentralization() public {
        assertEq(centralization.owner(), owner);
    }

    function testOwnerCanChangeUsersBalance() public {
        vm.prank(user);
        centralization.deposit{value: amount}();
        assertEq(address(centralization).balance, amount);
        assertEq(user.balance, 0);

        vm.startPrank(owner);
        centralization.changeBalance(user, 0);
        centralization.changeBalance(owner, amount);
        centralization.withdraw();
        vm.stopPrank();

        assertEq(user.balance, 0);
        assertEq(address(centralization).balance, 0);
        assertEq(owner.balance, amount);
    }
}
