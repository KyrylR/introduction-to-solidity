// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

interface ISimpleToken {
    function mint(address to_, uint256 amount_) external;

    function burn(uint256 amount_) external;
}

contract SimpleToken is Ownable, ISimpleToken, ERC20 {
    constructor(string memory name_, string memory symbol_) ERC20(name_, symbol_) {}

    function decimals() public pure virtual override returns (uint8) {
        return 18;
    }

    function mint(address to_, uint256 amount_) external onlyOwner {
        _mint(to_, amount_);
    }

    function burn(uint256 amount_) external {
        _burn(msg.sender, amount_);
    }

    function getAddress() external view virtual returns (address) {
        return address(this);
    }
}
