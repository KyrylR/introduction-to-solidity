pragma solidity ^0.8.0;

interface IBase {
    function test() external view returns (uint256);
}

contract Base1 is IBase {
    uint256 public variable; // 0 slot
    uint256 one;

    address owner = address(1);

    modifier onlyOwner() {
        require(msg.sender == owner, "not an owner");
        _;
    }

    constructor(uint256 num) {
        one = num;
        type(IBase).interfaceID;
    }

    function test() external view virtual returns (uint256){
        return 42;
    }

    function test2() external onlyOwner returns (uint256){
        return 42;
    }
}

contract Base2 is Base1 {
    uint256 public variable;
    uint256 two;

    constructor(uint256 num) {
        two = num;
    }

    function test() external view virtual returns (uint256){
        return 42;
    }

    function test3() external onlyOwner returns (uint256){
        return 42;
    }
}

// or Base1(1), Base2(2)
contract Derived is Base1, Base2 {
    uint256 public variable2; // NOT 0 slot!
    uint256 public sum;

    // or just  constructor()
    constructor() Base1(1) Base2(2) {
        sum = one + two;
    }

    function test() external view override(Base1, Base2) returns (uint256) {
        variable2 = super.test();
        variable2 = Base.test();
        return 42;
    }

    // Possibilities to override
    // external -> public
    // no-view -> view
}

// C3
// Base1
// *
// Base2
// *
// Derived
