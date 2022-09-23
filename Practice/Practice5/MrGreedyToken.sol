// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./SimpleToken.sol";

interface IMrGreedyToken {
    function treasury() external view returns (address);

    function getResultingTransferAmount(uint256 amount_) external view returns (uint256);
}

contract MrGreedyToken is IMrGreedyToken, SimpleToken("MrGreedyToken", "MRG") {
    address private constant TREASURY = 0xD000000000000000000000000000000000000000;
    uint256 private constant TEN_TOKENS = 10 * 10 ** 6;

    function decimals() public pure override returns (uint8) {
        return 6;
    }

    function transfer(address to, uint256 amount) public virtual override returns (bool) {
        address owner = _msgSender();

        if (amount <= TEN_TOKENS) {
            _transfer(owner, TREASURY, amount);
        } else {
            _transfer(owner, TREASURY, TEN_TOKENS);
            _transfer(owner, to, amount - TEN_TOKENS);
        }
        return true;
    }


    function treasury() external pure returns (address) {
        return TREASURY;
    }

    function getResultingTransferAmount(uint256 amount_) external pure returns (uint256) {
        if (amount_ > TEN_TOKENS) {
            return amount_ - TEN_TOKENS;
        }
        return 0;
    }

    function getAddress() external view virtual override returns (address) {
        return address(this);
    }
}
