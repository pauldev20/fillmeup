// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {HypNative} from "../src/HypNative.sol";

// deploy on two chains
// get addresses of deployed routers
// enroll routers
// separate script to send native tokens
// write handle functions for receiving native tokens
// deploy

contract SendNative is Script {
    HypNative public hypnative;

    uint32 constant ARBITRUM_SEPOLIA_CHAIN_ID = 421614;
    uint32 constant BASE_SEPOLIA_CHAIN_ID = 84531;
    uint32 constant SCROLL_SEPOLIA_CHAIN_ID = 534351;
    address constant BASE_SEPOLIA_MAILBOX = 0x6966b0E55883d49BFB24539356a2f8A673E02039;
    address constant ETHEREUM_SEPOLIA_MAILBOX = 0xfFAEF09B3cd11D9b20d1a19bECca54EEC2884766;
    address constant ARBITRUM_SEPOLIA_TESTRECIPIENT = 0x6c13643B3927C57DB92c790E4E3E7Ee81e13f78C;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        address mailbox = address(ETHEREUM_SEPOLIA_MAILBOX);

        hypnative = new HypNative(mailbox);
        hypnative.enrollRemoteRouter(SCROLL_SEPOLIA_CHAIN_ID, bytes32(uint256(uint160(address(this)))));
        hypnative.initialize(
            address(0),
            address(0),
            address(this)
        );
        payable(hypnative).transfer(0.001 ether);
        hypnative.transferRemote{value: 0.0001 ether}(
            SCROLL_SEPOLIA_CHAIN_ID,
            bytes32(uint256(uint160(ARBITRUM_SEPOLIA_TESTRECIPIENT))),
            100
        );

        vm.stopBroadcast();
    }
}
