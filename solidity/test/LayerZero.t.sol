// SPDX-License-Identifier: MIT
pragma solidity ^0.8.5;

import "forge-std/Test.sol";
import "../src/LayerZero.sol";
import {Util} from "../src/Util.sol";

contract LayerZeroTest is Test {
    uint32 dsteid_base_sepolia = 40245;

    function testLayerZeroExisting() public {
        // LayerZero lz = LayerZero(0xCF06f7BC9D3Cd7b068F059AB4c19f237F3A40F8C); // sepolia
        // uint256 nativeFee = lz.quote(
        //     dsteid_base_sepolia,
        //     1000,
        //     address(0x1337)
        // );
        // lz.send{value: nativeFee}(dsteid_base_sepolia, 1000, address(0x1337));
    }

    function testLayerZeroNewSingle() public {
        // LayerZero lz = new LayerZero(
        //     0x6EDCE65403992e310A62460808c4b910D972f10f,
        //     address(this)
        // ); // sepolia
        // lz.setPeer(
        //     dsteid_base_sepolia,
        //     Util.addressToBytes32(0x28a2e0927E6dfC55BBB9949A275deFB5Cf0A0B06)
        // );
        // uint256 nativeFee = lz.quote(
        //     dsteid_base_sepolia,
        //     1000,
        //     address(0x1337)
        // );
        // console.log(nativeFee);
        // lz.send{value: nativeFee}(dsteid_base_sepolia, 1000, address(0x1337));
    }

    LayerZero.sendData[] public data;

    function testLayerZeroNewBatch() public {
        LayerZero lz = new LayerZero(
            0x6EDCE65403992e310A62460808c4b910D972f10f,
            address(this)
        ); // sepolia
        lz.setPeer(
            dsteid_base_sepolia,
            Util.addressToBytes32(0x28a2e0927E6dfC55BBB9949A275deFB5Cf0A0B06)
        );
        uint256 cummulativeFee = 0;
        for (uint i = 0; i < 2; i++) {
            uint256 nativeFee = lz.quote(
                dsteid_base_sepolia,
                1000,
                address(0x1337)
            );
            data.push(LayerZero.sendData(dsteid_base_sepolia, 1000, nativeFee));
            cummulativeFee += nativeFee;
        }
        lz.sendBatch{value: cummulativeFee}(data, address(0x1337));
    }
}
