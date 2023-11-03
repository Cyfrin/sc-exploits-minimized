// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test} from "forge-std/Test.sol";
import {HandlerStatefulFuzzCatches} from "../../../src/invariant-break/HandlerStatefulFuzzCatches.sol";
import {YeildERC20} from "../../mocks/YeildERC20.sol";
import {MockUSDC} from "../../mocks/MockUSDC.sol";

contract Handler is Test {
    HandlerStatefulFuzzCatches handlerStatefulFuzzCatches;
    YeildERC20 yeildERC20;
    MockUSDC mockUSDC;
    address owner;

    constructor(HandlerStatefulFuzzCatches _handlerStatefulFuzzCatches, YeildERC20 _yeildERC20, MockUSDC _mockUSDC) {
        handlerStatefulFuzzCatches = _handlerStatefulFuzzCatches;
        yeildERC20 = _yeildERC20;
        mockUSDC = _mockUSDC;
        owner = yeildERC20.owner();
    }

    function depositYeildERC20(uint256 _amount) public {
        uint256 amount = bound(_amount, 0, yeildERC20.balanceOf(owner));
        vm.startPrank(owner);
        yeildERC20.approve(address(handlerStatefulFuzzCatches), amount);
        handlerStatefulFuzzCatches.depositToken(yeildERC20, amount);
        vm.stopPrank();
    }

    function depositMockUSDC(uint256 _amount) public {
        uint256 amount = bound(_amount, 0, mockUSDC.balanceOf(owner));
        vm.startPrank(owner);
        mockUSDC.approve(address(handlerStatefulFuzzCatches), amount);
        handlerStatefulFuzzCatches.depositToken(mockUSDC, amount);
        vm.stopPrank();
    }

    function withdrawYeildERC20() public {
        vm.startPrank(owner);
        handlerStatefulFuzzCatches.withdrawToken(yeildERC20);
        vm.stopPrank();
    }

    function withdrawMockUSDC() public {
        vm.startPrank(owner);
        handlerStatefulFuzzCatches.withdrawToken(mockUSDC);
        vm.stopPrank();
    }
}
