// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {
    StorageCollisionProxy, ImplementationA, ImplementationB
} from "../../src/storage-collision/StorageCollision.sol";

contract StorageCollisionTest is Test {
    StorageCollisionProxy public storageCollision;
    ImplementationA public implementationA;
    ImplementationB public implementationB;

    function setUp() public {
        storageCollision = new StorageCollisionProxy();
        implementationA = new ImplementationA();
        implementationB = new ImplementationB();
        storageCollision.setImplementation(address(implementationA));
    }

    function test_normalInteractionsStorageCollision() public {
        uint256 valueToSet = 10;
        uint256 valueStorageSlot = 0;
        ImplementationA(address(storageCollision)).setValue(valueToSet);
        assertEq(ImplementationA(address(storageCollision)).value(), valueToSet);
        assertEq(storageCollision.readStorage(valueStorageSlot), valueToSet);
    }

    function test_storageCollisionOnUpgrade() public {
        uint256 valueToSet = 10;
        uint256 valueStorageSlot = 0;
        ImplementationA(address(storageCollision)).setValue(valueToSet);
        assertEq(ImplementationA(address(storageCollision)).value(), valueToSet);
        assertEq(storageCollision.readStorage(valueStorageSlot), valueToSet);

        storageCollision.setImplementation(address(implementationB));
        // Storage is all messed up now
        // slot 0 is now a bool, but it still has the value 10 in it
        assertEq(storageCollision.readStorage(valueStorageSlot), valueToSet);
        // But calling `value` now returns 0
        assertEq(ImplementationB(address(storageCollision)).value(), 0);
        // And our bool defaulted to true because anything other than 0 in storage for a bool means it's true!
        assertEq(ImplementationB(address(storageCollision)).initialized(), true);
    }
}
