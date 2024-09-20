// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import "./LayerZero.sol";

interface WETH {
    function deposit() external payable;
    function withdraw(uint wad) external;
    function approve(address guy, uint wad) external returns (bool);
    function transferFrom(
        address src,
        address dst,
        uint wad
    ) external returns (bool);
}

contract BridgeSelector is Initializable {
    WETH public weth;
    LayerZero public lz;

    event Log(string func, uint256 gas);

    function initialize(address lzAddress, address weth_address) public initializer {
        lz = LayerZero(lzAddress);
        weth = WETH(weth_address);
    }

    function getLayerZeroQuote(uint32 dstEid, uint128 amount, address receiver) external view returns (uint256 fee) {
        return lz.quote(dstEid, amount, receiver);
    }

    function bridgeWithLayerZero(uint32 dstEid, uint128 amount, address receiver, uint256 fee) public {
        weth.transferFrom(receiver, address(this), fee);
        weth.withdraw(fee);
        lz.send{value: fee}(dstEid, amount, receiver);
    }

    receive() external payable {
        emit Log("receive", gasleft());
    }
}
