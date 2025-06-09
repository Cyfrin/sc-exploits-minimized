// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test} from "forge-std/Test.sol";
import {HandlerStatefulFuzzCatches} from "../../../src/invariant-break/HandlerStatefulFuzzCatches.sol";
import {YieldERC20} from "../../mocks/YieldERC20.sol";
import {MockUSDC} from "../../mocks/MockUSDC.sol";

contract Handler is Test {
    HandlerStatefulFuzzCatches handlerStatefulFuzzCatches;
    YieldERC20 yieldERC20;
    MockUSDC mockUSDC;
    address owner;

    constructor(HandlerStatefulFuzzCatches _handlerStatefulFuzzCatches, YieldERC20 _yieldERC20, MockUSDC _mockUSDC) {
        handlerStatefulFuzzCatches = _handlerStatefulFuzzCatches;
        yieldERC20 = _yieldERC20;
        mockUSDC = _mockUSDC;
        owner = yieldERC20.owner();
    }

    function depositYieldERC20(uint256 _amount) public {
        uint256 amount = bound(_amount, 0, yieldERC20.balanceOf(owner));
        vm.startPrank(owner);
        yieldERC20.approve(address(handlerStatefulFuzzCatches), amount);
        handlerStatefulFuzzCatches.depositToken(yieldERC20, amount);
        vm.stopPrank();
    }

    function depositMockUSDC(uint256 _amount) public {
        uint256 amount = bound(_amount, 0, mockUSDC.balanceOf(owner));
        vm.startPrank(owner);
        mockUSDC.approve(address(handlerStatefulFuzzCatches), amount);
        handlerStatefulFuzzCatches.depositToken(mockUSDC, amount);
        vm.stopPrank();
    }

    function withdrawYieldERC20() public {
        vm.startPrank(owner);
        handlerStatefulFuzzCatches.withdrawToken(yieldERC20);
        vm.stopPrank();
    }

    function withdrawMockUSDC() public {
        vm.startPrank(owner);
        handlerStatefulFuzzCatches.withdrawToken(mockUSDC);
        vm.stopPrank();
    }
}
