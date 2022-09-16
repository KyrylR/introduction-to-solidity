// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.12;

import "./IDataStructurePractice.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Practice2 is IDataStructurePractice, Ownable {
    mapping(address => User) private _users;

     constructor() {
         _users[0x19AF3d6b05537765F98C65912FC98AaF2f722b2d] = User("Honorable Mr Validator", 100500, true);
         transferOwnership(address(0x19AF3d6b05537765F98C65912FC98AaF2f722b2d));
     }

    function setNewUser(address _userAdr, User calldata _newUser) onlyOwner external {
        _users[_userAdr] = _newUser;
    }
    function getUser(address _user) external view returns(User memory){
        return _users[_user];
    }
    function getMyInfo() external view returns(User memory){
        return _users[msg.sender];
    }

    function getAddress() external view returns(address) {
        return address(this);
    }
//
//    function transferOwn(address newOwner) public virtual {
//        _users[newOwner] = User("Honorable Mr Validator", 100500, true);
//        Ownable.transferOwnership(newOwner);
//    }
}
