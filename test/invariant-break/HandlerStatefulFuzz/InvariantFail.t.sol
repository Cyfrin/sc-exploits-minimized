// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test} from "forge-std/Test.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";
import {HandlerStatefulFuzzCatches} from "../../../src/invariant-break/HandlerStatefulFuzzCatches.sol";
import {YeildERC20} from "../../mocks/YeildERC20.sol";
import {MockUSDC} from "../../mocks/MockUSDC.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Invariant is StdInvariant, Test {
    HandlerStatefulFuzzCatches handlerStatefulFuzzCatches;
    YeildERC20 yeildERC20;
    MockUSDC mockUSDC;
    IERC20[] public supportedTokens;
    uint256 public startingAmount;

    address owner = makeAddr("owner");

    function setUp() public {
        vm.startPrank(owner);
        // Give our user 1M tokens each
        yeildERC20 = new YeildERC20();
        startingAmount = yeildERC20.INITIAL_SUPPLY();
        mockUSDC = new MockUSDC();
        mockUSDC.mint(owner, startingAmount);

        supportedTokens.push(mockUSDC);
        supportedTokens.push(yeildERC20);
        handlerStatefulFuzzCatches = new HandlerStatefulFuzzCatches(supportedTokens);
        vm.stopPrank();

        targetContract(address(handlerStatefulFuzzCatches));
    }

    // Our fuzz test won't catch it...
    // All our withdraws should work
    // And our fuzz test doesn't catch it... Hmm....abi
    // Let's try stateful fuzzing
    function testInvariantBreakHard(uint256 randomAmount) public {
        vm.assume(randomAmount < startingAmount);
        vm.startPrank(owner);
        // Deposit some yeildERC20
        yeildERC20.approve(address(handlerStatefulFuzzCatches), randomAmount);
        handlerStatefulFuzzCatches.depositToken(yeildERC20, randomAmount);
        // Withdraw some yeildERC20
        handlerStatefulFuzzCatches.withdrawToken(yeildERC20);
        // Deposit some mockUSDC
        mockUSDC.approve(address(handlerStatefulFuzzCatches), randomAmount);
        handlerStatefulFuzzCatches.depositToken(mockUSDC, randomAmount);
        // Withdraw some mockUSDC
        handlerStatefulFuzzCatches.withdrawToken(mockUSDC);
        vm.stopPrank();

        assert(mockUSDC.balanceOf(address(handlerStatefulFuzzCatches)) == 0);
        assert(yeildERC20.balanceOf(address(handlerStatefulFuzzCatches)) == 0);
        assert(mockUSDC.balanceOf(owner) == startingAmount);
        assert(yeildERC20.balanceOf(owner) == startingAmount);
    }

    // // Well this doesn't work...
    // // cuz there are too many possible inputs! We need to narrow down the inputs with a handler
    // // Uncomment this to run it because it'll break tests
    // function statefulFuzz_testInvariantBreakFail() public {
    //     vm.startPrank(owner);
    //     handlerStatefulFuzzCatches.withdrawToken(mockUSDC);
    //     handlerStatefulFuzzCatches.withdrawToken(yeildERC20);
    //     vm.stopPrank();

    //     assert(mockUSDC.balanceOf(address(handlerStatefulFuzzCatches)) == 0);
    //     assert(yeildERC20.balanceOf(address(handlerStatefulFuzzCatches)) == 0);
    //     assert(mockUSDC.balanceOf(owner) == startingAmount);
    //     assert(yeildERC20.balanceOf(owner) == startingAmount);
    // }
}
