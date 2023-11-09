//SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

// Note: NOT EIP 3156 compliant https://eips.ethereum.org/EIPS/eip-3156
interface IFlashLoanReceiver {
    function execute() external payable;
}
