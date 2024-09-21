// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../src/LayerZero.sol";
import {Script, console} from "forge-std/Script.sol";
import {Util} from "../src/Util.sol";

contract Deploy is Script {
    function run() public {
        // for all these chains same endpoint address
        address endpoint = 0x6EDCE65403992e310A62460808c4b910D972f10f;
        address morph_endpoint = 0x6C7Ab2202C98C4227C5c46f1417D81144DA716Ff;

        vm.createSelectFork(vm.rpcUrl("sepolia"));
        vm.broadcast();
        new LayerZero(endpoint, msg.sender);

        vm.createSelectFork(vm.rpcUrl("base_sepolia"));
        vm.broadcast();
        new LayerZero(endpoint, msg.sender);

        vm.createSelectFork(vm.rpcUrl("arbitrum_sepolia"));
        vm.broadcast();
        new LayerZero(endpoint, msg.sender);

        vm.createSelectFork(vm.rpcUrl("polygon_amoy"));
        vm.broadcast();
        new LayerZero(endpoint, msg.sender);

        vm.createSelectFork(vm.rpcUrl("optimism_sepolia"));
        vm.broadcast();
        new LayerZero(endpoint, msg.sender);

        vm.createSelectFork(vm.rpcUrl("morph_testnet"));
        vm.broadcast();
        new LayerZero(morph_endpoint, msg.sender);
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
        peers.push(
            Peer("sepolia", 40161, 0x13b50021965171557cB0d6f3a2AAF1F86fCDEA94)
        );
        peers.push(
            Peer(
                "base_sepolia",
                40245,
                0x83473d55A8b4415B980d51EC9753c8Fb19D26f82
            )
        );
        peers.push(
            Peer(
                "arbitrum_sepolia",
                40231,
                0x0b18692D2f4059F13baA765816bFBD07776F7D8B
            )
        );
        peers.push(
            Peer(
                "polygon_amoy",
                40267,
                0x0b18692D2f4059F13baA765816bFBD07776F7D8B
            )
        );
        peers.push(
            Peer(
                "optimism_sepolia",
                40232,
                0x0b18692D2f4059F13baA765816bFBD07776F7D8B
            )
        );
        peers.push(
            Peer(
                "morph_testnet",
                40322,
                0x0b18692D2f4059F13baA765816bFBD07776F7D8B
            )
        );
    }

    function run() public {
        uint i = 1;
        // uint j = 1;
        LayerZero lz = LayerZero(peers[i].peer);
        vm.createSelectFork(vm.rpcUrl(peers[i].rpcAlias));
        vm.startBroadcast();
        for (uint j = 0; j < peers.length; j++) {
            if (i == j) continue;
            lz.setPeer(peers[j].eid, Util.addressToBytes32(peers[j].peer));
        }
        vm.stopBroadcast();
        // lz.setPeer(peers[j].eid, Util.addressToBytes32(peers[j].peer));
    }

    // always one transaction failing...
    // function run() public {
    //     for (uint i = 0; i < peers.length; i++) {
    //         LayerZero lz = LayerZero(peers[i].peer);
    //         vm.createSelectFork(vm.rpcUrl(peers[i].rpcAlias));
    //         vm.startBroadcast();
    //         for (uint j = 0; j < peers.length; j++) {
    //             if (i == j) continue;
    //             lz.setPeer(peers[j].eid, Util.addressToBytes32(peers[j].peer));
    //         }
    //         vm.stopBroadcast();
    //     }
    // }
}

contract Send is Script {
    function run() public {
        // uint32 dsteid_base_sepolia = 40245;
        // uint128 amount = 1000;
        // address reciever = address(0x1234A41BF51Fb34877317e66A322586D67b00C2C);
        // LayerZero lz = LayerZero(0xCF06f7BC9D3Cd7b068F059AB4c19f237F3A40F8C); // sepolia
        // uint256 nativeFee = lz.quote(dsteid_base_sepolia, amount, reciever);
        // vm.createSelectFork(vm.rpcUrl("sepolia"));
        // vm.broadcast();
        // lz.send{value: nativeFee}(dsteid_base_sepolia, amount, reciever);
    }
}
