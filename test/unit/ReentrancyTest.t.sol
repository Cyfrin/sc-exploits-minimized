// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {ReentrancyVictim, ReentrancyAttacker} from "../../src/reentrancy/Reentrancy.sol";

contract ReentrancyTest is Test {
    ReentrancyVictim public victimContract;
    ReentrancyAttacker public attackerContract;

    address victimUser = makeAddr("victimUser");
    address attackerUser = makeAddr("attackerUser");

    uint256 amountToDeposited = 5 ether;
    uint256 attackerCapital = 1 ether;

    function setUp() public {
        victimContract = new ReentrancyVictim();
        attackerContract = new ReentrancyAttacker(victimContract);

        vm.deal(victimUser, amountToDeposited);
        vm.deal(attackerUser, attackerCapital);
    }

    function test_reenter() public {
        // User deposits 5 ETH
        vm.prank(victimUser);
        victimContract.deposit{value: amountToDeposited}();

        // We assert the user has their balance
        assertEq(victimContract.userBalance(victimUser), amountToDeposited);

        // // Normally, the user could now withdraw their money if they like
        // vm.prank(victimUser);
        // victimContract.withdrawBalance();

        // But... we get attacked!
        vm.prank(attackerUser);
        attackerContract.attack{value: 1 ether}();

        assertEq(victimContract.userBalance(victimUser), amountToDeposited);
        assertEq(address(victimContract).balance, 0);

        vm.prank(victimUser);
        vm.expectRevert();
        victimContract.withdrawBalance();
    }
}
