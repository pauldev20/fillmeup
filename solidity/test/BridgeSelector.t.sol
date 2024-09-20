// SPDX-License-Identifier: MIT
pragma solidity ^0.8.5;

import "forge-std/Test.sol";
import {WETH, BridgeSelector} from "../src/BridgeSelector.sol";
import {LayerZero} from "../src/LayerZero.sol";
import {Util} from "../src/Util.sol";

import {Options} from "openzeppelin-foundry-upgrades/Options.sol";
import {Upgrades} from "openzeppelin-foundry-upgrades/Upgrades.sol";

contract LayerZeroTest is Test {
    BridgeSelector selector;
    WETH weth;
    uint32 dsteid_base_sepolia = 40245;

    event Log(string func, uint256 gas);

    function setUp() public {
        LayerZero lz = new LayerZero(
            0x6EDCE65403992e310A62460808c4b910D972f10f,
            address(this)
        ); // sepolia
        
        lz.setPeer(dsteid_base_sepolia, Util.addressToBytes32(0x28a2e0927E6dfC55BBB9949A275deFB5Cf0A0B06));
        selector = new BridgeSelector();
        selector.initialize(address(lz), 0x7b79995e5f793A07Bc00c21412e50Ecae098E7f9);
        weth = selector.weth();
        weth.deposit{value: 100 ether}();
    }

    // function testBridgeSelectorWETH() public {
    //     address me = address(0x1337);
    //     vm.startPrank(me);
    //     vm.deal(me, 1 ether);
    //     vm.assertEq(1 ether, me.balance);
    //     weth.deposit{value: 1 ether}();
    //     vm.assertEq(0 ether, me.balance);
    //     weth.withdraw(1 ether);
    //     vm.assertEq(1 ether, me.balance);
    // }

    function testBridgeSelector() public {
        uint256 nativeFee = selector.lz().quote(dsteid_base_sepolia, 1000, address(this));
        weth.approve(address(selector), nativeFee);
        console.log(nativeFee);
        selector.bridgeWithLayerZero(dsteid_base_sepolia, 1000, address(this), nativeFee);
    }
}

// 90691341592445
// 90691341592445


//     ├─ [119587] LayerZero::send{value: 90691341592445}(40245 [4.024e4], 1000, 0x0000000000000000000000000000000000001337)
//    │     ├─ [0] LayerZero::send{value: 90691341592445}(40245 [4.024e4], 1000, LayerZeroTest: [0x7FA9385bE102ac3EAc297483Dd6233D62b3e1496])
