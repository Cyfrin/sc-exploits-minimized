// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

/*
 * @notice A minimal protocol treasury whose funds can only be moved by governance.
 * @notice It is the target of the governance attack: once an attacker controls a
 *         passing proposal, they make governance call `withdraw` to drain the ETH.
 */
contract Treasury {
    address public immutable i_governance;

    error Treasury__NotGovernance();
    error Treasury__TransferFailed();

    constructor(address governance) {
        i_governance = governance;
    }

    function withdraw(address to) external {
        if (msg.sender != i_governance) {
            revert Treasury__NotGovernance();
        }
        (bool success,) = to.call{value: address(this).balance}("");
        if (!success) {
            revert Treasury__TransferFailed();
        }
    }

    receive() external payable {}
}
