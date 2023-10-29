// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract YeildERC20 is ERC20 {
    uint256 public constant INITIAL_SUPPLY = 1_000_000e18;
    address public immutable owner;
    // We take a fee once every 10 transactions
    uint256 public count = 0;
    uint256 public constant FEE = 10;
    uint256 public constant USER_AMOUNT = 90;
    uint256 public constant PRECISION = 100;

    constructor() ERC20("MockYeildERC20", "MYEILD") {
        owner = msg.sender;
        _mint(msg.sender, INITIAL_SUPPLY);
    }

    /**
     * @dev Transfers a `value` amount of tokens from `from` to `to`, or alternatively mints (or burns) if `from`
     * (or `to`) is the zero address. All customizations to transfers, mints, and burns should be done by overriding
     * this function.
     *
     * Every 10 transactions, we take a fee of 10% and send it to the owner.
     */
    function _update(address from, address to, uint256 value) internal virtual override {
        if (to == owner) {
            super._update(from, to, value);
        } else if (count >= 10) {
            uint256 userAmount = value * USER_AMOUNT / PRECISION;
            uint256 ownerAmount = value * FEE / PRECISION;
            count = 0;
            super._update(from, to, userAmount);
            super._update(from, owner, ownerAmount);
        } else {
            count++;
            super._update(from, to, value);
        }
    }
}
