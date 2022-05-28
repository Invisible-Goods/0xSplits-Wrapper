// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "../lib/ISplitMain.sol";
import "../lib/GasFreeBase.sol";

contract Polygon_GasFreeSplit_Upgradeable is OwnableUpgradeable, GasFreeBase {
    /**
     * @dev Initializes contract variables.
     * @param _trustedForwarderAddress - initial address to be trusted forwarder.
     */
    function initialize(address _trustedForwarderAddress) public initializer {
        __Ownable_init();
        _trustedForwarder = _trustedForwarderAddress;
    }

    /**
     * return the sender of this call.
     * if the call came through our trusted forwarder, return the original sender.
     * otherwise, return `msg.sender`.
     * should be used in the contract anywhere instead of msg.sender
     */
    function _msgSender()
        internal
        view
        virtual
        override(GasFreeBase, ContextUpgradeable)
        returns (address ret)
    {
        return GasFreeBase._msgSender();
    }

    /**
     * return the msg.data of this call.
     * if the call came through our trusted forwarder, then the real sender was appended as the last 20 bytes
     * of the msg.data - so this method will strip those 20 bytes off.
     * otherwise (if the call was made directly and not through the forwarder), return `msg.data`
     * should be used in the contract instead of msg.data, where this difference matters.
     */
    function _msgData()
        internal
        view
        virtual
        override(ContextUpgradeable, GasFreeBase)
        returns (bytes calldata ret)
    {
        return GasFreeBase._msgData();
    }
}
