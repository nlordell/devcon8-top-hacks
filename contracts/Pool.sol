// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/// @title A simple ETH pool
/// @notice Depositors receive shares proportional to their deposit. Any ETH
/// sent directly to the pool (e.g. fees) is shared among all share holders.
contract Pool {
    uint256 public totalShares;
    mapping(address => uint256) public sharesOf;

    event Deposit(address indexed owner, uint256 assets, uint256 shares);
    event Withdraw(address indexed owner, uint256 assets, uint256 shares);

    /// @notice Accept fees, which increase the value of every share.
    receive() external payable {}

    function totalAssets() public view returns (uint256) {
        return address(this).balance;
    }

    /// @notice Deposit ETH in exchange for shares.
    function deposit() external payable returns (uint256 shares) {
        uint256 assetsBefore = totalAssets() - msg.value;
        if (totalShares == 0) {
            shares = msg.value;
        } else {
            shares = (msg.value * totalShares) / assetsBefore;
        }
        require(shares > 0, "zero shares");

        sharesOf[msg.sender] += shares;
        totalShares += shares;
        emit Deposit(msg.sender, msg.value, shares);
    }

    /// @notice Withdraw an exact amount of ETH, burning the shares it is worth.
    function withdraw(uint256 assets) external returns (uint256 shares) {
        shares = (assets * totalShares) / totalAssets();

        sharesOf[msg.sender] -= shares;
        totalShares -= shares;
        emit Withdraw(msg.sender, assets, shares);

        (bool success,) = msg.sender.call{value: assets}("");
        require(success, "transfer failed");
    }
}
