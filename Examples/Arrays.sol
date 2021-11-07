// SPDX-License-Identifier: MIT

pragma solidity ^0.8.6;

contract ExampleArray {
  // dynamic length array
  bytes32[] public names;

  // fixed length array
  bytes[4] public fNames;


  // array testing function
  function arrTest() public returns (uint) {
    // assign array inline
    string[4] memory _inlineArray = ["sam", "mike", "peter", "macky"];

    // multi dimensional array
    uint[3][] memory multiArray;

    // assign array element
    fNames[0] = "Chris";

    // push to array
    names.push("Ron");
    names.push("Jack");

    // initializing multi dimensional array
    multiArray = new uint[3][](2); // number of rows = 2

    // assign 
    multiArray[0][1] = 20;

    return multiArray[0][1];

  }

  // getter of fNames
  function getFNamesLength() public view returns (uint256) {
    return fNames.length;
  }

  // getter of names
  function getNamesLength() public view returns (uint256) {
    return names.length;
  }



}