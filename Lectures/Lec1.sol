pragma solidity ^0.8.9;

uint256 constant PRECISION = 10*27;

contract TestLec1 {
    function sum() external {
        // TODO
    }
}

contract TestLec2 {
    function sum() external {
        // TODO
    }
}

contract Lec1 {
    function test2(address lec2) external {
        TestLec2(lec2).sum();
    }

    // bool
    // uint256
    // bytes32
    // int256
    // bytes4

    // address uint160 bytes20

    // function test() external {
    //     bool &&, ||

    //     uint256 +, -, *, /, &, **

    //     bytes32 = keccak256()
    // }

    function test(address payable user) external returns (uint256) {
        // user.transfer(...)
        // payable(user).call()
        uint256 one = 0.01 ether; // 10 ** 16
        uint256 t = 10 * PRECISION / 100;
        return t;
    }

    //  string
    //  bytes

    //  uint256[][][][][][]

    //  address[]

    //  bytes32[]

    // storage
    // memory
    // calldata

    function test() external {
        // uint256[] tt;
        // uint256[] memory tt;
        uint256[] memory tt = new uint256[](10);

        uint256[] memory tt2 = tt; // pointer
    }

    // calldata is imutable (able to read, forbiden to write)
    // only in params
    function test(uint256[] calldata) external {
        // user.a;
    }

    // mapping(address => string)
    // mapping(address => address)

    struct User {
        uint256 a;
        uint256 b;

        mapping(address => address) c;
    }

    // User user;

    // msg
    // msg.sender
    // msg.data
    // msg.value

    // tx
    // tx.origin

    // block
    // block.number
    // block.timestamp
    // block.coinbase


    // this
    // address(this)
    // this.test()

    // transferFrom(from, address(this), value);
    // // ----------from, to '-> (me)' , value

    // super

    // uint256 public lll;
    // uint256 lll2; // getter will NOT be genereted

    // public // you can read from external world (getter will be genereted)
    // private  // rw only for this contract
    // internal // rw only for this contract AND for contract's children


    // external // funcs only
}

contract Lec1_2 is Lec1 {
    // {
    //     uint256 inner;
    // }

    // Outer of the scope
    // inner = 10;
}

// Lec1.lll()
