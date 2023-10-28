// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract Centralization {
    address public owner;
    mapping(address => uint256) public balances;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() external {
        require(balances[msg.sender] > 0, "Insufficient balance");
        uint256 balanceToReturn = balances[msg.sender];
        balances[msg.sender] = 0;
        (bool succ,) = payable(msg.sender).call{value: balanceToReturn}("");
        require(succ);
    }

    function changeBalance(address user, uint256 balance) external onlyOwner {
        balances[user] = balance;
    }
}
