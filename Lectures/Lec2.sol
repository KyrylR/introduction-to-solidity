pragma solidity ^0.8.0;

contract Lec2 {
    // calldata only available in external function (only able to read)
    function Lec2(string calldata stc) external view {
        // memory (lie in their own place (able to read and write)
        string memory s = "asdasd";

        // ask, where to place in 0x40, ex 0x40 -> 0x120 .....
        // ..... now 0x40 will point roughly to 0x170
        string memory stm;
        string memory stm2;
        sts = stm; // deep copy
        // the same with sts = stm;

        stm2 = stm; // cheap operation (stm2 is starting point to place in memory of stm)
        // Deep copy when stm = stc

        // memory, calldata -> storage = deepcopy
        // calldata -> memory = deepcopy
        // memory -> memory, calldata -> calldata, storage -> storage = referencecopy
    }
    // big endian representation?
    // storage
    // slot 0 = ...
    // slot 1 = ...
    // slot 2 = ...
    // .....
    // slot n = ...

    string sts; // res = keccak256(0) <- 0 is slot 0
    // slot res (number) will be the place where var stored

    // ----------------------------------------------------------------------------------------------------
    struct User {
        uint256 balance; // 32 bytes (0 slot)
        uint64 lastDepositTimestamp; // 1 slot
        bool claimed; // 1 slot

        mapping(uint256 => uint256) nfts;
    }
    // 0000.....bool...uint64...000...uint256

    // 1 slot = 32 bytes
    User user; // 0

    function test() external view returns() {
        User storage user2 = user;
        test2(user2);
    }

    function test2(User storage user2) internal {}

    mapping(uint256 => User) userById; // 2 slot, key = 123 ------ keccak256(2123) = user value slot

    // Maximum 256 values
    enum Type {
        RED, // == 0
        BLUE
    }

    // after london hardfork
    uint256 variable = 1;
    uint256 variable2;

    uint256[] array3;
    mapping(uint256 => address) map;

    function test(uint256[] calldata array) external {
        variable2 = 2; // 20 000 ....
        uint256 localVariable = variable; // first read 2100
        uint256 localVariable2 = variable; // second read 100

        uint256[] memory array2 = array; // deep copy (use only if we need multiple accesses
        array[2]; // very cheap operation

        delete variable; // equivalent to variable = 0;

        delete array3; // len = 0, push over old vars

        selfdestruct(address(0)); // eliminated all byte code for this contact
        // if there was an ethereum it sends it to provided address
    }
}
