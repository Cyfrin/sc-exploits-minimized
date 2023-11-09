// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {MessageHashUtils} from "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";
import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import {EIP712} from "@openzeppelin/contracts/utils/cryptography/EIP712.sol";

contract SignatureReplay is EIP712 {
    bytes32 public constant TYPEHASH = keccak256("withdrawBySig(uint256 amount)");

    error SignatureReplay__InsufficientBalance(uint256 currentBalance, uint256 amount);

    mapping(address => uint256) public balances;

    constructor() EIP712("SignatureReplay", "1") {}

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) external payable {
        _withdraw(msg.sender, amount);
    }

    // Vulnerable to replay and front running attacks!
    function withdrawBySig(uint8 v, bytes32 r, bytes32 s, uint256 amount) external payable {
        bytes32 structHash = keccak256(abi.encode(TYPEHASH, amount));
        bytes32 hash = _hashTypedDataV4(structHash);
        address signer = ECDSA.recover(hash, v, r, s);
        _withdraw(signer, amount);
    }

    function _withdraw(address user, uint256 amount) private {
        uint256 currentBalance = balances[user];
        if (currentBalance < amount) {
            revert SignatureReplay__InsufficientBalance(currentBalance, amount);
        }
        balances[user] = currentBalance - amount;
        payable(user).transfer(amount);
    }

    // Prevention:
    // - keep track of a nonce
    // - make the current nonce available to signers
    // - validate the signature using the current nonce
    // - once a nonce has been used, save this to storage such that the same nonce can't be used again
    // - give it an expiration

    // Helper function
    function getHashTypedDataV4(bytes32 structHash) external view returns (bytes32) {
        return _hashTypedDataV4(structHash);
    }
}
