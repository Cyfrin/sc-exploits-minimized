// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

interface IFrontRan {
    function withdraw(string memory password) external;
}

contract Bouncer {
    error Bouncer__NotOwner();
    error Bouncer__DidntMoney();

    address s_owner;
    address s_frontRan;

    constructor(address frontRan) payable {
        s_owner = msg.sender;
        s_frontRan = frontRan;
    }

    function go(string memory password) external {
        if (msg.sender != s_owner) {
            revert Bouncer__NotOwner();
        }
        IFrontRan(s_frontRan).withdraw(password);
        (bool success,) = payable(s_owner).call{value: address(this).balance}("");
        if (!success) {
            revert Bouncer__DidntMoney();
        }
    }

    receive() external payable {}
}
