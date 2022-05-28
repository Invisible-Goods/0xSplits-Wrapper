// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "../lib/ISplitMain.sol";
import "../lib/GasFreeBase.sol";

contract Polygon_GasFreeSplit is GasFreeBase {
    /**
     * @dev Initializes contract variables.
     * @param _trustedForwarderAddress - initial address to be trusted forwarder.
     */
    constructor(address _trustedForwarderAddress) {
        _trustedForwarder = _trustedForwarderAddress;
        splits = ISplitMain(0x2ed6c4B5dA6378c7897AC67Ba9e43102Feb694EE);
    }
}
