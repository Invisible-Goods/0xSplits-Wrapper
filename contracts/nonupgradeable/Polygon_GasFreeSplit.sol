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
    }
}
