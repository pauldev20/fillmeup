// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../src/LayerZero.sol";
import {Script, console} from "forge-std/Script.sol";
import {Util} from "../src/Util.sol";

contract Deploy is Script {
    function run() public {
        address sepoliaEndpoint = 0x6EDCE65403992e310A62460808c4b910D972f10f;
        address baseSepoliaEndpoint = 0x6EDCE65403992e310A62460808c4b910D972f10f;

        vm.createSelectFork(vm.rpcUrl("sepolia"));
        vm.broadcast();
        new LayerZero(sepoliaEndpoint, msg.sender);

        vm.createSelectFork(vm.rpcUrl("base_sepolia"));
        vm.broadcast();
        new LayerZero(baseSepoliaEndpoint, msg.sender);
    }
}

contract SetPeer is Script {
    struct Peer {
        string rpcAlias;
        uint32 eid;
        address peer;
    }
    Peer[] public peers;

    function setUp() public {
        address addr = 0xCF06f7BC9D3Cd7b068F059AB4c19f237F3A40F8C;

        peers.push(Peer("sepolia", 40161, addr));
        peers.push(Peer("base_sepolia", 40245, addr));
    }

    function run() public {
        for (uint i = 0; i < peers.length; i++) {
            LayerZero lz = LayerZero(peers[i].peer);
            vm.createSelectFork(vm.rpcUrl(peers[i].rpcAlias));
            vm.startBroadcast();
            for (uint j = 0; j < peers.length; j++) {
                if (i == j) continue;
                lz.setPeer(peers[j].eid, Util.addressToBytes32(peers[j].peer));
            }
            vm.stopBroadcast();
        }
    }
}

contract Send is Script {
    function run() public {
        uint32 dsteid_base_sepolia = 40245;
        uint128 amount = 1000;
        address reciever = address(0x1234A41BF51Fb34877317e66A322586D67b00C2C);

        LayerZero lz = LayerZero(0xCF06f7BC9D3Cd7b068F059AB4c19f237F3A40F8C); // sepolia
        uint256 nativeFee = lz.quote(
            dsteid_base_sepolia,
            amount,
            reciever
        );

        vm.createSelectFork(vm.rpcUrl("sepolia"));
        vm.broadcast();
        lz.send{value: nativeFee}(
            dsteid_base_sepolia,
            amount,
            reciever
        );
    }
}
