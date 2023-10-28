// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Proxy} from "@openzeppelin/contracts/proxy/Proxy.sol";

contract StorageCollisionProxy is Proxy {
    bytes32 private constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    function setImplementation(address newImplementation) public {
        assembly {
            sstore(_IMPLEMENTATION_SLOT, newImplementation)
        }
    }

    function _implementation() internal view override returns (address implementationAddress) {
        assembly {
            implementationAddress := sload(_IMPLEMENTATION_SLOT)
        }
    }

    // helper function
    function getDataToTransact(uint256 numberToUpdate) public pure returns (bytes memory) {
        return abi.encodeWithSignature("setValue(uint256)", numberToUpdate);
    }

    function readStorage(uint256 storageSlot) public view returns (uint256 vauleAtStorageSlot) {
        assembly {
            vauleAtStorageSlot := sload(storageSlot)
        }
    }

    receive() external payable {
        _fallback();
    }
}

contract ImplementationA {
    uint256 public value;

    function setValue(uint256 newValue) public {
        value = newValue;
    }
}

contract ImplementationB {
    // Ah!!! This will ruin the storage of our proxy!!
    bool public initialized;
    // Why did we switch the order??
    uint256 public value;

    function setValue(uint256 newValue) public {
        value = newValue + 2;
    }
}
