// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./SimpleToken.sol";

interface IMrGreedyToken {
    function treasury() external view returns (address);

    function getResultingTransferAmount(uint256 amount_) external view returns (uint256);
}

contract MrGreedyToken is IMrGreedyToken, SimpleToken("MrGreedyToken", "MRG") {
    address constant treasury_ = 0xD000000000000000000000000000000000000000;

    function decimals() public pure override returns (uint8) {
        return 6;
    }

    function transfer(address to, uint256 amount) public virtual override returns (bool) {
        address owner = _msgSender();

        uint256 tenTokens_ = 10 * 10 ** decimals();

        if (amount <= tenTokens_) {
            _transfer(owner, treasury_, amount);
        } else {
            _transfer(owner, treasury_, tenTokens_);
            _transfer(owner, to, amount - tenTokens_);
        }
        return true;
    }


    function treasury() external view returns (address) {
        return treasury_;
    }

    function getResultingTransferAmount(uint256 amount_) external pure returns (uint256) {
        return amount_ - 10 * decimals();
    }

    function getAddress() external view virtual override returns (address) {
        return address(this);
    }
}
