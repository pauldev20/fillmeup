// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { Upgrades } from "../lib/openzeppelin-foundry-upgrades/src/Upgrades.sol";
import "../src/BridgeSelector.sol";
import {Script, console} from "forge-std/Script.sol";

contract DeployNormal is Script {
    LayerZero lz;
    address weth;

    function setUp() public {
        lz = LayerZero(address(0x11545fE290A922c557274D4b53Ef3880175D40D8));
        lz.quote(40245, 1000, address(0x1337)); // test to see if address is correct
        weth = 0x7b79995e5f793A07Bc00c21412e50Ecae098E7f9;
    }

    function run() public {
        vm.createSelectFork(vm.rpcUrl("sepolia"));
        vm.startBroadcast();
        new BridgeSelector(address(lz), weth);
        vm.stopBroadcast();
    }
}

contract TransferTest is Script {
    BridgeSelector selector;
    uint32 dsteid_base_sepolia = 40245;
    uint32 dsteid_morph = 40322;

    function setUp() public {
        selector = BridgeSelector(payable(0x290e31032c33331D724298544663dB502C8cC77D));
    }

    LayerZero.sendData[] public data;

    function run() public {
        vm.createSelectFork(vm.rpcUrl("sepolia"));
        vm.startBroadcast();

        uint256 cummulativeFee = 0;
        for (uint i = 0; i < 1; i++) {
            uint256 nativeFee = selector.lz().quote(
                dsteid_morph,
                1000,
                msg.sender 
            );
            data.push(LayerZero.sendData(dsteid_morph, 1000, nativeFee));
            cummulativeFee += nativeFee;
        }

        selector.weth().deposit{value: cummulativeFee}();
        selector.weth().approve(address(selector), cummulativeFee);
        selector.bridgeWithLayerZero(data, msg.sender, cummulativeFee);
        vm.stopBroadcast();

        // uint256 nativeFee = selector.getLayerZeroQuote(dsteid_base_sepolia, 1000, msg.sender);
        // selector.weth().deposit{value: nativeFee}();
        // selector.weth().approve(address(selector), nativeFee);
        // selector.bridgeWithLayerZero(dsteid_base_sepolia, 1000, msg.sender, nativeFee); 

        // vm.stopBroadcast();
    }
}


// doesn't work because of the payable stuff

// contract DeployProxy is Script {
//     LayerZero lz;
//     address weth;

//     function setUp() public {
//         lz = LayerZero(address(0xCF06f7BC9D3Cd7b068F059AB4c19f237F3A40F8C));
//         lz.quote(40245, 1000, address(0x1337)); // test to see if address is correct
//         weth = 0x7b79995e5f793A07Bc00c21412e50Ecae098E7f9;
//     }

//     function run() public {
//         vm.createSelectFork(vm.rpcUrl("sepolia"));
//         vm.startBroadcast();
//         address proxyAddr = Upgrades.deployTransparentProxy(
//             "BridgeSelectorV1.sol:BridgeSelectorV1", 
//             address(this), 
//             abi.encodeCall(BridgeSelectorV1.initialize, (address(lz), weth))
//         );
//         vm.stopBroadcast();
//         console.log(proxyAddr);
//     }
// }

// contract UpgradeProxy is Script {
//     address proxyAddr;

//     function setUp() public {
//         proxyAddr = 0xCab837E80b687dB66A28A8A50f4C98B1009493d5;
//     }

//     function run() public {
//         // Upgrades.upgradeProxy(
//         //     proxyAddr, 
//         //     "LayerZero3.sol:Counter3", 
//         //     abi.encodeCall(Counter3.initialize, (69))
//         // );
//         // console.logUint(ICounter(proxyAddr).getNumber());
//         // console.logUint(ICounter(proxyAddr).kekw());

//         // Upgrades.upgradeProxy(proxy, contractName, data, opts); 
//         // vm.broadcast();
//     }
// }
