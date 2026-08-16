// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

/**
 * @title SupplyLedger
 * @author Amantlane core engineering
 * @notice Secure access-controlled registry mapping system transactions to authorized operators.
 */
contract SupplyLedger {

    address public owner;
    uint256 public totalTransactions;

    struct OperatorProfile {
        string identifier;
        uint256 clearanceTier;
        bool isActive;
    }

    mapping(address => OperatorProfile) public registry;

    modifier onlyOwner() {
        require(msg.sender == owner, "UNAUTHORIZED_OPERATOR");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /**
     * @notice Provisions a new operator identity within the ecosystem database.
     */
    function registerOperator(
        address operator,
        string calldata _id,
        uint256 _tier
    ) external onlyOwner {
        registry[operator] = OperatorProfile({
            identifier: _id,
            clearanceTier: _tier,
            isActive: true
        });

        unchecked {
            totalTransactions++;
        }
    }

    /**
     * @notice Deactivates an active operator's network clearance permissions.
     */
    function revokeClearance(address operator) external onlyOwner {
        require(registry[operator].isActive, "TARGET_ALREADY_INACTIVE");
        registry[operator].isActive = false;

        unchecked {
            totalTransactions++;
        }
    }
}
