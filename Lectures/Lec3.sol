pragma solidity ^0.8.0;

contract Lec3 {
    uint256 public variable;

    // external (only from outer world)
    // public (inside and outside)
    // internal (inside and inheritance)
    // private (only inside)

    // view (only read from storage)
    // pure (only for math, very restricted)
    // payable (can accept ether)

    // Libs in JS
    // web3.js -- currently in use
    // ethers.js -- better

    // ABI

    function Lec3(uint256 num) external {

    }

    // selector -> Lec3(uint256) -> keccak256() -> first 4 bytes.

    // receive
    // fallback

    // Data must be empty
    receive() external payable {}

    // [payable]
    fallback() external {}

    // this.Lec3() very expensive (simulate call function from outer world)
}
