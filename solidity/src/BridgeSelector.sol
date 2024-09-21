// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

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

interface HypNative {
    function transferRemote(
        uint32 _destination,
        bytes32 _recipient,
        uint256 _amount
    ) external payable;
    function quoteGasPayment(
        uint32 eid
    ) external view returns (uint256);
}

contract BridgeSelector {
    WETH public weth;
    LayerZero public lz;
    HypNative public hypNative;

    constructor(
        address lzAddress,
        address hypNativeAddress,
        address weth_address
    ) {
        lz = LayerZero(lzAddress);
        hypNative = HypNative(hypNativeAddress);
        weth = WETH(weth_address);
    }

    function getLayerZeroQuote(
        uint32 dstEid,
        uint128 amount,
        address receiver
    ) external view returns (uint256 fee) {
        return lz.quote(dstEid, amount, receiver);
    }

    function bridgeWithLayerZero(
        LayerZero.sendData[] calldata data,
        address receiver,
        uint256 cummulativeFee
    ) public {
        weth.transferFrom(receiver, address(this), cummulativeFee);
        weth.withdraw(cummulativeFee);
        lz.sendBatch{value: cummulativeFee}(data, receiver);
    }

    function getHyperlaneQuote(
        uint32 dstEid,
        uint256 amount
    ) external view returns (uint256 fee) {
        return hypNative.quoteGasPayment(dstEid);
    }

    function bridgeWithHyperlane(
        uint32 dstEid,
        uint256 amount,
        address receiver
    ) public payable {
        uint256 gas = hypNative.quoteGasPayment(dstEid) + amount;
        weth.transferFrom(receiver, address(this), gas);
        weth.withdraw(gas);
        hypNative.transferRemote{value: gas}(
            dstEid,
            bytes32(uint256(uint160(receiver))),
            amount
        );
    }

    receive() external payable {}
}
