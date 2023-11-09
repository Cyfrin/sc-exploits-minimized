// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {IFlashLoanReceiver} from "./IFlashLoanReceiver.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract FlashLoaner {
    error RepayFailed();

    IERC20 public immutable token;

    constructor(address _token) {
        token = IERC20(_token);
    }

    function flashLoan(uint256 amount) external {
        uint256 balanceBefore = token.balanceOf(address(this));

        token.transfer(msg.sender, amount);
        IFlashLoanReceiver(msg.sender).execute();

        if (token.balanceOf(address(this)) < balanceBefore) {
            revert RepayFailed();
        }
    }
}
