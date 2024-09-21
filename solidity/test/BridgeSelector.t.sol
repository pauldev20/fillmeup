// SPDX-License-Identifier: MIT
pragma solidity ^0.8.5;

import "forge-std/Test.sol";
import {WETH, BridgeSelectorV1} from "../src/BridgeSelectorV1.sol";
import {LayerZero} from "../src/LayerZero.sol";
import {Util} from "../src/Util.sol";

import {Options} from "openzeppelin-foundry-upgrades/Options.sol";
import {Upgrades} from "openzeppelin-foundry-upgrades/Upgrades.sol";

contract BridgeSelectorTest is Test {
    // BridgeSelectorV1 selector;
    // WETH weth;
    uint32 dsteid_base_sepolia = 40245;

    event Log(string func, uint256 gas);

    function setUpContract() public returns (BridgeSelectorV1 selector) {
        LayerZero lz = new LayerZero(
            0x6EDCE65403992e310A62460808c4b910D972f10f,
            address(this)
        ); // sepolia
        
        lz.setPeer(dsteid_base_sepolia, Util.addressToBytes32(0x28a2e0927E6dfC55BBB9949A275deFB5Cf0A0B06));
        selector = new BridgeSelectorV1();
        selector.initialize(address(lz), 0x7b79995e5f793A07Bc00c21412e50Ecae098E7f9);
        // selector.weth().deposit{value: 100 ether}();
    }

    function testBridgeSelectorWETH() public {
        BridgeSelectorV1 selector = setUpContract();
        address me = address(0x1337);
        vm.startPrank(me);
        vm.deal(me, 1 ether);
        vm.assertEq(1 ether, me.balance);
        selector.weth().deposit{value: 1 ether}();
        vm.assertEq(0 ether, me.balance);
        selector.weth().withdraw(1 ether);
        vm.assertEq(1 ether, me.balance);
    }

    function testBridgeSelectorNew() public {
        BridgeSelectorV1 selector = setUpContract();
        uint256 nativeFee = selector.lz().quote(dsteid_base_sepolia, 1000, address(this));
        selector.weth().approve(address(selector), nativeFee);
        console.log(nativeFee);
        selector.bridgeWithLayerZero(dsteid_base_sepolia, 1000, address(this), nativeFee);
    }

    function testBridgeSelectorExisting() public {
        // BridgeSelectorV1 selector = setUpContract();
        vm.startPrank(address(0x1337));
        vm.deal(address(0x1337), 10 ether);
        BridgeSelectorV1 selector = BridgeSelectorV1(payable(0x903A4726c67e5Ea06Edf29CA780c539B5137d170));
        uint256 nativeFee = selector.getLayerZeroQuote(dsteid_base_sepolia, 1000, address(0x1337));
        selector.weth().deposit{value: 1 ether}();
        selector.weth().approve(address(selector), nativeFee);
        selector.bridgeWithLayerZero(dsteid_base_sepolia, 1000, address(0x1337), nativeFee); 
    }

    receive() external payable {
    }
}
