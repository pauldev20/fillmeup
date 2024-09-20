// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Initializable} from "../lib/openzeppelin-contracts/contracts/proxy/utils/Initializable.sol";
import {OApp, Origin, MessagingFee} from "@layerzerolabs/oapp-evm/contracts/oapp/OApp.sol";
import {OptionsBuilder} from "@layerzerolabs/oapp-evm/contracts/oapp/libs/OptionsBuilder.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Util} from "./Util.sol";

contract LayerZero is OApp {
    constructor(
        address _endpoint,
        address _owner
    ) OApp(_endpoint, _owner) Ownable(_owner) {}

    using OptionsBuilder for bytes;

    /**
     * @notice Sends a message from the source to destination chain.
     * @param dstEid Destination chain's endpoint ID.
     * @param amount Amount of native tokens to send
     * @param receiver Reciever of native tokens
     */
    function send(
        uint32 dstEid,
        uint128 amount,
        address receiver
    ) external payable {
        bytes memory options = OptionsBuilder
            .newOptions()
            .addExecutorLzReceiveOption(200000, 0)
            .addExecutorNativeDropOption(
                amount,
                Util.addressToBytes32(receiver)
            );
        _lzSend(
            dstEid,
            bytes(""),
            options,
            MessagingFee(msg.value, 0),
            payable(msg.sender)
        );
    }

    // function fund(
    //     address receiver,
    //     uint32[] calldata _dstEids
    // ) external {

    // }

    /**
     * @dev We can keep this empty, since we are just using the message to send native tokens.
     * @param _origin A struct containing information about where the packet came from.
     * @param _guid A global unique identifier for tracking the packet.
     * @param payload Encoded message.
     */
    function _lzReceive(
        Origin calldata _origin,
        bytes32 _guid,
        bytes calldata payload,
        address,
        bytes calldata
    ) internal override {}

    function quote(
        uint32 _dstEid,
        uint128 amount,
        address receiver
    ) public view returns (uint256 nativeFee) {
        bytes memory options = OptionsBuilder
            .newOptions()
            .addExecutorLzReceiveOption(200000, 0)
            .addExecutorNativeDropOption(
                amount,
                Util.addressToBytes32(receiver)
            );
        MessagingFee memory fee = _quote(_dstEid, bytes(""), options, false);
        return fee.nativeFee;
    }
}
