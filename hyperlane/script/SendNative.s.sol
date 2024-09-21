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
    function setUp() public {}

    function run() public {
		uint256[] memory fork_ids = new uint256[](2);
        fork_ids[0] = vm.createFork(vm.rpcUrl("source_chain"));
		fork_ids[1] = vm.createFork(vm.rpcUrl("destination_chain"));

        HypNative[] memory routers = new HypNative[](2);
		routers[0] = HypNative(payable(vm.envAddress("ROUTER_0_ADDRESS")));
		routers[1] = HypNative(payable(vm.envAddress("ROUTER_1_ADDRESS")));

		vm.selectFork(fork_ids[0]);
		vm.startBroadcast();
		uint256 gas = routers[0].quoteGasPayment(uint32(vm.envUint("DESTINATION_CHAIN_ID")));
		console.log("Gas payment: ", gas);
		routers[0].transferRemote{value:gas+100}(
			uint32(vm.envUint("DESTINATION_CHAIN_ID")),
			bytes32(uint256(uint160(vm.envAddress("ROUTER_1_ADDRESS")))),
			100
		);
		vm.stopBroadcast();
    }
}
