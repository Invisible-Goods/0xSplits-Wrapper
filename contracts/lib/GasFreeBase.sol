// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "../lib/ISplitMain.sol";

contract GasFreeBase {
    // Mapping of contract address to isSplit bool.
    mapping(address => bool) internal splitsAddresses;
    // EIP2771 - Forwarder singleton we accept calls from.
    address internal _trustedForwarder;
    /// @notice constant to scale uints into percentages (1e6 == 100%)
    uint256 public constant PERCENTAGE_SCALE = 1e6;
    // 0xSplits Contract Factory Interface.
    ISplitMain internal splits;

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
     * @dev Calls updateSplit in 0xSplit hyperstructure contract.
     * @param split - address of the split to update.
     * @param accounts - array of split recipient addresses.
     * @param percentAllocations - array of percent allocation uint32.
     * @param distributorFee - fee for whoever distributes funds in the split.
     */
    function updateSplit(
        address split,
        address[] calldata accounts,
        uint32[] calldata percentAllocations,
        uint32 distributorFee
    ) external {
        splits.updateSplit(split, accounts, percentAllocations, distributorFee);
    }

    /**
     * @dev Calls transferControl in 0xSplit hyperstructure contract.
     * @param split - address of the split to transfer.
     * @param newController - address of the newController.
     */
    function transferControl(address split, address newController) external {
        splits.transferControl(split, newController);
    }

    /**
     * @dev Calls cancelControlTransfer in 0xSplit hyperstructure contract.
     * @param split - address of the split to cancel transfer.
     */
    function cancelControlTransfer(address split) external {
        splits.cancelControlTransfer(split);
    }

    /**
     * @dev Calls acceptControl in 0xSplit hyperstructure contract.
     * @param split - address of the split to accept transfer.
     */
    function acceptControl(address split) external {
        splits.acceptControl(split);
    }

    /**
     * @dev Calls makeSplitImmutable in 0xSplit hyperstructure contract.
     * @param split - address of the split to make immutable.
     */
    function makeSplitImmutable(address split) external {
        splits.makeSplitImmutable(split);
    }

    /**
     * @dev Calls distributeETH in 0xSplit hyperstructure contract.
     * @param split - address of the split to distribute.
     * @param accounts - array of split recipient addresses.
     * @param percentAllocations - array of percent allocation uint32.
     * @param distributorFee - fee paid to distributorAddress.
     * @param distributorAddress - address of distributor.
     */
    function distributeETH(
        address split,
        address[] calldata accounts,
        uint32[] calldata percentAllocations,
        uint32 distributorFee,
        address distributorAddress
    ) external {
        splits.distributeETH(
            split,
            accounts,
            percentAllocations,
            distributorFee,
            distributorAddress
        );
    }

    /**
     * @dev Calls updateAndDistributeETH in 0xSplit hyperstructure contract.
     * @param split - address of the split to update/distribute.
     * @param accounts - array of split recipient addresses.
     * @param percentAllocations - array of percent allocation uint32.
     * @param distributorFee - fee paid to distributorAddress.
     * @param distributorAddress - address of distributor.
     */
    function updateAndDistributeETH(
        address split,
        address[] calldata accounts,
        uint32[] calldata percentAllocations,
        uint32 distributorFee,
        address distributorAddress
    ) external {
        splits.updateAndDistributeETH(
            split,
            accounts,
            percentAllocations,
            distributorFee,
            distributorAddress
        );
    }

    /**
     * @dev Calls distributeERC20 in 0xSplit hyperstructure contract.
     * @param split - address of the split to distribute.
     * @param token - ERC20 token to distribute.
     * @param accounts - array of split recipient addresses.
     * @param percentAllocations - array of percent allocation uint32.
     * @param distributorFee - fee paid to distributorAddress.
     * @param distributorAddress - address of distributor.
     */
    function distributeERC20(
        address split,
        ERC20 token,
        address[] calldata accounts,
        uint32[] calldata percentAllocations,
        uint32 distributorFee,
        address distributorAddress
    ) external {
        splits.distributeERC20(
            split,
            token,
            accounts,
            percentAllocations,
            distributorFee,
            distributorAddress
        );
    }

    /**
     * @dev Calls updateAndDistributeERC20 in 0xSplit hyperstructure contract.
     * @param split - address of the split to update/distribute.
     * @param token - ERC20 token to distribute.
     * @param accounts - array of split recipient addresses.
     * @param percentAllocations - array of percent allocation uint32.
     * @param distributorFee - fee paid to distributorAddress.
     * @param distributorAddress - address of distributor.
     */
    function updateAndDistributeERC20(
        address split,
        ERC20 token,
        address[] calldata accounts,
        uint32[] calldata percentAllocations,
        uint32 distributorFee,
        address distributorAddress
    ) external {
        splits.updateAndDistributeERC20(
            split,
            token,
            accounts,
            percentAllocations,
            distributorFee,
            distributorAddress
        );
    }

    /**
     * @dev Calls withdraw in 0xSplit hyperstructure contract.
     * @param account - address to withdraw on behalf of.
     * @param withdrawETH - withdraw all ETH if nonzero.
     * @param tokens - addresses of ERC20s to withdraw.
     */
    function withdraw(
        address account,
        uint256 withdrawETH,
        ERC20[] calldata tokens
    ) external {
        splits.withdraw(account, withdrawETH, tokens);
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
    function _msgSender() internal view virtual returns (address ret) {
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
    function _msgData() internal view virtual returns (bytes calldata ret) {
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

    /**
     * @dev Checks if address is 0xSplit wallet.
     * @param splitAddress - contract addresses to check.
     */
    function isSplit(address splitAddress) public view returns (bool) {
        return splitsAddresses[splitAddress];
    }
}