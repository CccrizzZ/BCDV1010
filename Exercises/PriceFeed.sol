
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

contract PriceFeed { 
  
    uint private _price = 42;
    
    // price getter
    function getPrice() public view returns (uint) {
        return _price;
    }
  
    // price setter  
    function setPrice(uint256 newPrice) public {
        // require the address to have atleast 1 ether to change price
        require(address(this).balance >= 1 ether, "contract balance should be at least 1 ether");
        
        // set the price if passed the require
        _price = newPrice;
    }
    
    // function that pays this contract
    function pay() public payable{
        
    }
    
}


contract setPriceFeed{
    // call the PriceFeed contract and set its price
    function setPrice(PriceFeed PriceFeedRef, uint256 newPrice) public {
        return PriceFeedRef.setPrice(newPrice);
    }
}