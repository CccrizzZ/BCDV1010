// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

contract WorkingWithVariables {
  uint256 public myUint;
  bool public myBool;
  uint8 public myUint8;
  address public myAddress;
  string public myString = "Hello World";



  // public setter function for uint
  function setMyUint(uint256 input) public {
    myUint = input;
  }

  // public setter function for bool
  function setMyBool(bool input) public {
    myBool = input;
  }

  // public setter function for uint8
  function incrementUint8() public {
    myUint8++;
  }

  // underflow or overflow will throw error
  function decrementUint8() public {
    myUint8--;
  }


  // address related function
  function setAddress(address input) public {
    myAddress = input;
  }

  function getBalanceOfAccount() public view returns (uint) {
    return myAddress.balance;
  }

  // string related function
  function setMyString(string memory input) public {
    myString = input;
  }

}

