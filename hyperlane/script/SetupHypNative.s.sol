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

contract SetupHypNative is Script {
    // uint32 constant ARBITRUM_SEPOLIA_CHAIN_ID = 421614;
    // uint32 constant BASE_SEPOLIA_CHAIN_ID = 44787;
    // uint32 constant SCROLL_SEPOLIA_CHAIN_ID = 534351;
    // uint32 constant ETHEREUM_SEPOLIA_CHAIN_ID = 11155111;
    // address constant BASE_SEPOLIA_MAILBOX = 0xEf9F292fcEBC3848bF4bB92a96a04F9ECBb78E59;
    // address constant ETHEREUM_SEPOLIA_MAILBOX = 0xfFAEF09B3cd11D9b20d1a19bECca54EEC2884766;
    // address constant ETHEREUM_SEPOLIA_PAYMASTER = 0x6f2756380FD49228ae25Aa7F2817993cB74Ecc56;
    // address constant ARBITRUM_SEPOLIA_TESTRECIPIENT = 0x6c13643B3927C57DB92c790E4E3E7Ee81e13f78C;
    // uint256 constant BASE_SEPOLIA_BLOCK_NUMBER = 15569563;
    // uint256 constant ETHEREUM_SEPOLIA_BLOCK_NUMBER = 6732165;

    function setUp() public {}

    function initRouters(
        uint256[] memory fork_ids,
        HypNative[] memory routers
    ) public {
        vm.selectFork(fork_ids[0]);
        vm.startBroadcast();
        routers[0] = new HypNative(vm.envAddress("SOURCE_CHAIN_MAILBOX"));
        routers[0].initialize(
            address(0),
            address(0),
            address(msg.sender)
        );
        vm.stopBroadcast();
        vm.selectFork(fork_ids[1]);
        vm.startBroadcast();
        console.log(vm.envAddress("DESTINATION_CHAIN_MAILBOX"));
        routers[1] = new HypNative(vm.envAddress("DESTINATION_CHAIN_MAILBOX"));
        routers[1].initialize(
            address(0),
            address(0),
            address(msg.sender)
        );
        vm.stopBroadcast();
    }

    function enrollRouters(
        uint256[] memory fork_ids,
        HypNative[] memory routers,
        uint32[] memory chain_ids,
        address[] memory router_addresses
    ) public {
        bytes32[] memory router_bytes32 = new bytes32[](router_addresses.length);
        for (uint i = 0; i < router_addresses.length; i++) {
            router_bytes32[i] = bytes32(uint256(uint160(router_addresses[i])));
        }
        vm.selectFork(fork_ids[0]);
        vm.broadcast();
        routers[0].enrollRemoteRouter(chain_ids[1], router_bytes32[1]);
        vm.selectFork(fork_ids[1]);
        vm.broadcast();
        routers[1].enrollRemoteRouter(chain_ids[0], router_bytes32[0]);
    }

    function run() public {
        uint256[] memory fork_ids = new uint256[](2);
        fork_ids[0] = vm.createFork(vm.rpcUrl("source_chain"));
        fork_ids[1] = vm.createFork(vm.rpcUrl("destination_chain"));

        HypNative[] memory routers = new HypNative[](2);

        initRouters(fork_ids, routers);
        console.log("routers deployed");
        console.log("router 0 address: ", address(routers[0]));
        console.log("router 1 address: ", address(routers[1]));

        uint32[] memory chain_ids = new uint32[](2);
        chain_ids[0] = uint32(vm.envUint("SOURCE_CHAIN_ID"));
        chain_ids[1] = uint32(vm.envUint("DESTINATION_CHAIN_ID"));
        address[] memory router_addresses = new address[](2);
        router_addresses[0] = address(routers[0]);
        router_addresses[1] = address(routers[1]);
        enrollRouters(fork_ids, routers, chain_ids, router_addresses);
        console.log("routers enrolled");
    }
}
