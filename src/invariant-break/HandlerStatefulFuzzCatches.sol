// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

/*
 * This contract represents a vault for ERC20 tokens.
 *
 * INVARIANT: Users must always be able to withdraw the exact balance amout out. 
 */
contract HandlerStatefulFuzzCatches {
    error HandlerStatefulFuzzCatches__UnsupportedToken();

    using SafeERC20 for IERC20;

    mapping(IERC20 => bool) public tokenIsSupported;
    mapping(address user => mapping(IERC20 token => uint256 balance)) public tokenBalances;

    modifier requireSupportedToken(IERC20 token) {
        if (!tokenIsSupported[token]) revert HandlerStatefulFuzzCatches__UnsupportedToken();
        _;
    }

    constructor(IERC20[] memory _supportedTokens) {
        for (uint256 i; i < _supportedTokens.length; i++) {
            tokenIsSupported[_supportedTokens[i]] = true;
        }
    }

    function depositToken(IERC20 token, uint256 amount) external requireSupportedToken(token) {
        tokenBalances[msg.sender][token] += amount;
        token.safeTransferFrom(msg.sender, address(this), amount);
    }

    function withdrawToken(IERC20 token) external requireSupportedToken(token) {
        uint256 currentBalance = tokenBalances[msg.sender][token];
        tokenBalances[msg.sender][token] = 0;
        token.safeTransfer(msg.sender, currentBalance);
    }
}
