// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {MishandlingOfEth, MishandlingOfEthAttacker} from "../../src/mishandling-of-eth/MishandlingOfEth.sol";
import {SelfDestructMe, AttackSelfDestructMe} from "../../src/mishandling-of-eth/SelfDestructMe.sol";

contract MishandlingOfEthTest is Test {
    MishandlingOfEth public mishandlingOfEth;
    MishandlingOfEthAttacker public mishandlingOfEthAttacker;
    uint256 public constant AMOUNT = 1 ether;

    address personA = makeAddr("A");
    address personB = makeAddr("B");
    address personC = makeAddr("C");
    address attackerEoA = makeAddr("attackerEoA");

    function setUp() public {
        mishandlingOfEth = new MishandlingOfEth();
        mishandlingOfEthAttacker = new MishandlingOfEthAttacker(mishandlingOfEth);
        vm.deal(personA, AMOUNT);
        vm.deal(personB, AMOUNT);
        vm.deal(personC, AMOUNT);
        vm.deal(attackerEoA, AMOUNT);
    }

    function test_mishandlingOfEthLocked() public {
        vm.prank(personA);
        mishandlingOfEth.enter{value: AMOUNT}();
        vm.prank(personB);
        mishandlingOfEth.enter{value: AMOUNT}();
        vm.prank(personC);
        mishandlingOfEth.enter{value: AMOUNT}();

        vm.prank(attackerEoA);
        mishandlingOfEthAttacker.attack{value: AMOUNT}();

        vm.expectRevert();
        mishandlingOfEth.sendBack();
    }

    function test_selfDestructMeBreaksContract() public {
        SelfDestructMe selfDestructMe = new SelfDestructMe();

        vm.deal(msg.sender, 1 ether);
        AttackSelfDestructMe attackSelfDestructMe = new AttackSelfDestructMe{value: 1 ether}(selfDestructMe);

        vm.prank(personA);
        selfDestructMe.deposit{value: AMOUNT}();
        vm.prank(personB);
        selfDestructMe.deposit{value: AMOUNT}();
        vm.prank(personC);
        selfDestructMe.deposit{value: AMOUNT}();

        vm.prank(attackerEoA);
        attackSelfDestructMe.attack{value: AMOUNT}();

        vm.expectRevert();
        vm.prank(personA);
        selfDestructMe.withdraw();
    }
}
