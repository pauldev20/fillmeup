// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {HypNative} from "../src/HypNative.sol";

contract SendNative is Script {
    HypNative public hypnative;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        address mailbox = address(0x6966b0E55883d49BFB24539356a2f8A673E02039);

        hypnative = new HypNative(mailbox);

        vm.stopBroadcast();
    }
}
