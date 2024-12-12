pragma solidity >=0.8.2 <0.9.0;
// SPDX-License-Identifier: MIT

interface IMyTokenError {
    error InvalidSenderAddress(address sender);
    error InvalidReceiverAddress(address receiver);
    error InvalidOwnerAddress(address owner);
    error InvalidSpenderAddress(address spender);
    error InsufficientBalance(address _spender, uint256 balance, uint256 required);
    error InsufficientAllowances(address _owner, address _spender, uint256 allowanceBalance, string allowanceName);
}