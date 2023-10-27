// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

// Inspired by https://github.com/crytic/slither/wiki/Detector-Documentation#weak-prng

contract WeakRandomness {
    /*
     * @notice A fair random number generator
     */
    function getRandomNumber() external view returns (uint256) {
        uint256 randomNumber = uint256(keccak256(abi.encodePacked(msg.sender, block.prevrandao, block.timestamp)));
        return randomNumber;
    }
}

// prevrandao security considerations: https://eips.ethereum.org/EIPS/eip-4399
