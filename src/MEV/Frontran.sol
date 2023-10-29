// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract FrontRan {
    error BadWithdraw();

    bytes32 public s_secretHash;

    event success();
    event fail();

    constructor(bytes32 secretHash) payable {
        s_secretHash = secretHash;
    }

    function withdraw(string memory password) external payable {
        if (keccak256(abi.encodePacked(password)) == s_secretHash) {
            (bool sent,) = msg.sender.call{value: address(this).balance}("");
            if (!sent) {
                revert BadWithdraw();
            }
            emit success();
        } else {
            emit fail();
        }
    }

    function balance() external view returns (uint256) {
        return address(this).balance;
    }
}
