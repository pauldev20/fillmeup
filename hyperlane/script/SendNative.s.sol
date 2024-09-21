// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {HypNative} from "../src/HypNative.sol";

contract SendNative is Script {
    HypNative public hypnative;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        address mailbox = address(0x1234567890123456789012345678901234567890);

        hypnative = new HypNative(mailbox);

        vm.stopBroadcast();
    }
}
