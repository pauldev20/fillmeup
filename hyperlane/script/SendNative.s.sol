// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Counter} from "../src/HypNative.sol";

contract SendNative is Script {
    HypNative public hypnative;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        hypnative = new HypNative();

        vm.stopBroadcast();
    }
}
