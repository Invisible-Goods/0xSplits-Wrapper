// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "../lib/ISplitMain.sol";

contract Polygon_GasFreeSplit_Upgradeable is OwnableUpgradeable {
    // Mapping of contract address to isSplit bool.
    mapping(address => bool) internal splitsAddresses;
    // EIP2771 - Forwarder singleton we accept calls from.
    address private _trustedForwarder;
    /// @notice constant to scale uints into percentages (1e6 == 100%)
    uint256 public constant PERCENTAGE_SCALE = 1e6;

    /**
     * @dev Initializes contract variables.
     * @param _trustedForwarderAddress - initial address to be trusted forwarder.
     */
    function initialize(address _trustedForwarderAddress) public initializer {
        __Ownable_init();
        _trustedForwarder = _trustedForwarderAddress;
    }

    /**
     * @dev Calls createSplit in 0xSplit hyperstructure contract.
     * @param accounts - array of split recipient addresses.
     * @param percentAllocations - array of percent allocation uint32.
     * @param distributorFee - fee for whoever distributes funds in the split.
     * @param controller - controller of the split contract.
     */
    function createSplit(
        address[] memory accounts,
        uint32[] memory percentAllocations,
        uint32 distributorFee,
        address controller
    ) public returns (address) {
        ISplitMain splits = ISplitMain(
            0x2ed6c4B5dA6378c7897AC67Ba9e43102Feb694EE
        );
        address newSplit = splits.createSplit(
            accounts,
            percentAllocations,
            distributorFee,
            controller
        );
        splitsAddresses[newSplit] = true;
        return newSplit;
    }

    /**
     * @dev Checks if address is 0xSplit wallet.
     * @param splitAddress - contract addresses to check.
     */
    function isSplit(address splitAddress) public view returns (bool) {
        return splitsAddresses[splitAddress];
    }

    /**
     * @dev EIP2771 - Checks if address is _trustedForwarder.
     * @param forwarder - address to compare.
     */
    function isTrustedForwarder(address forwarder)
        public
        view
        virtual
        returns (bool)
    {
        return forwarder == _trustedForwarder;
    }

    /**
     * return the sender of this call.
     * if the call came through our trusted forwarder, return the original sender.
     * otherwise, return `msg.sender`.
     * should be used in the contract anywhere instead of msg.sender
     */
    function _msgSender() internal view virtual override returns (address ret) {
        if (msg.data.length >= 20 && isTrustedForwarder(msg.sender)) {
            // At this point we know that the sender is a trusted forwarder,
            // so we trust that the last bytes of msg.data are the verified sender address.
            // extract sender address from the end of msg.data
            assembly {
                ret := shr(96, calldataload(sub(calldatasize(), 20)))
            }
        } else {
            ret = msg.sender;
        }
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
        override
        returns (bytes calldata ret)
    {
        if (msg.data.length >= 20 && isTrustedForwarder(msg.sender)) {
            return msg.data[0:msg.data.length - 20];
        } else {
            return msg.data;
        }
    }

    /**
     * @dev Returns address of truster forwarder.
     */
    function trustedForwarder() public view virtual returns (address) {
        return _trustedForwarder;
    }

    /**
     * @dev returns versionRecipient.
     */
    function versionRecipient() external pure returns (string memory) {
        return "1";
    }
}
