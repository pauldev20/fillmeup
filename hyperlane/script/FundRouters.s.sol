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

contract FundRouters is Script {
    function setUp() public {}

    function run() public {
		uint256[] memory fork_ids = new uint256[](2);
        fork_ids[0] = vm.createFork(vm.rpcUrl("source_chain"));
		fork_ids[1] = vm.createFork(vm.rpcUrl("destination_chain"));

        HypNative[] memory routers = new HypNative[](2);
		routers[0] = HypNative(payable(vm.envAddress("ROUTER_0_ADDRESS")));
		routers[1] = HypNative(payable(vm.envAddress("ROUTER_1_ADDRESS")));

		vm.selectFork(fork_ids[1]);
		vm.broadcast();
		payable(routers[1]).transfer(0.01 ether);
		vm.selectFork(fork_ids[0]);
		vm.broadcast();
		payable(routers[0]).transfer(0.01 ether);
    }
}
