// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

contract GetAddress{
    // calculate contract address with caller address and nonce
    function getContractAddress(address caller, uint256 nonce) public pure returns(address){
        
        return address(uint160(uint256(keccak256(abi.encodePacked(bytes1(0xd6), bytes1(0x94), caller, bytes1(uint8(nonce)))))));
    }
}