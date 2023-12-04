// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test} from "forge-std/Test.sol";
import {FormalVerificationCatches} from "../../../src/invariant-break/FormalVerificationCatches.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";
import {KontrolCheats} from "kontrol-cheatcodes/KontrolCheats.sol";

contract KontrolTest is StdInvariant, Test, KontrolCheats {
    FormalVerificationCatches fvc;

    function setUp() public {
        fvc = new FormalVerificationCatches();
    }

    function check_hellFunc_doesnt_revert_kontrol(uint128 num) public {
        // perform low level call
        kevm.infiniteGas();
        (bool success,) = address(fvc).staticcall(abi.encodeWithSelector(fvc.hellFunc.selector, num));
        assert(success);
    }
}
