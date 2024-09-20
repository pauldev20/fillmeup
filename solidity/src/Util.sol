// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

library Util {
    function addressToBytes32(address _addr) internal pure returns (bytes32) {
        return bytes32(uint256(uint160(_addr)));
    }
}
