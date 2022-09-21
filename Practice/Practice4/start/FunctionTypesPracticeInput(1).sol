// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.9;

interface IFirst {
    function setPublic(uint256 num) external;
    function setPrivate(uint256 num) external;
    function setInternal(uint256 num) external;
    function sum() external view returns (uint256);
    function sumFromSecond(address contractAddress) external returns (uint256);
    function callExternalReceive(address payable contractAddress) external payable;
    function callExternalFallback(address payable contractAddress) external payable;
    function getSelector() external pure returns (bytes memory);
}

interface ISecond {
    function withdrawSafe(address payable holder) external;
    function withdrawUnsafe(address payable holder) external;
}

interface IAttacker {
    function increaseBalance() external payable;
    function attack() external;
}

contract First {
    uint256 public ePublic;
    uint256 private ePrivate;
    uint256 internal eInternal;
}

contract Second {
    mapping(address => uint256) public balance;
}

