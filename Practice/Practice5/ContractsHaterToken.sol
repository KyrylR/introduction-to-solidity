// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./SimpleToken.sol";

interface IContractsHaterToken {
    function addToWhitelist(address candidate_) external;

    function removeFromWhitelist(address candidate_) external;
}

contract ContractsHaterToken is SimpleToken("ContractsHaterToken", "CHT"), IContractsHaterToken {
    mapping(address => bool) private whitelist;

    function addToWhitelist(address candidate_) external onlyOwner {
        whitelist[candidate_] = true;
    }

    function removeFromWhitelist(address candidate_) external onlyOwner {
        whitelist[candidate_] = false;
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 /*amount*/
    ) internal view override {
        if (from != address(0) && to != address(0) && to != address(this)) {
            require(!isContract(to) || whitelist[to], "Failed to send token. Sending a token to this contract is not allowed.");
        }
    }

    function isContract(address _addr) private view returns (bool){
        uint32 size;
        assembly {
            size := extcodesize(_addr)
        }
        return (size > 0);
    }

    function getAddress() external view virtual override returns (address) {
        return address(this);
    }
}
