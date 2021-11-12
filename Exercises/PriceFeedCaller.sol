// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;


// the contract to be called
contract PriceFeed {
    uint private price = 42;
    
    function setPrice(uint newPrice) public payable { 
        price = newPrice; 
    }
    
    function getPrice() public view returns (uint) { 
        return price; 
    }
    
    function getSender() public view returns (address) { 
        return msg.sender; 
    }
    
    function getOrigin() public view returns (address) { 
        return tx.origin; 
    }
    
    function getAddress() public view returns (address) { 
        return address(this); 
    }
}





// caller contract
contract Caller {
    event logResult(string, bytes);
    
    // address of the target contract
    address public feed;
    
    // caller price
    uint public price = 33;
    
    // set up with the deployed pricefeed contract address
    function setup(address addr) public {
        require(addr != address(0));
        feed = addr;
    }

    function getPrice() public returns(uint) {
        // (bool success, bytes memory ret) = feed.staticcall(abi.encodeWithSignature("getPrice()"));
        
        (bool success, bytes memory ret) = feed.delegatecall(abi.encodeWithSignature("getPrice()"));
        
        require(success);
        
        //emit logResult("getPrice", ret);
        return (abi.decode(ret, (uint)));
    }
    
    
    function getSender() public view returns(address){
        (bool success, bytes memory sd) = feed.staticcall(abi.encodeWithSignature("getSender()"));      // this contract address
        // (bool success, bytes memory sd) = feed.delegatecall(abi.encodeWithSignature("getSender()")); // EOA address
         
        require(success);
        return (abi.decode(sd, (address)));
    }
    
    
    function getOrigin() public returns(address){ 
        // (bool success, bytes memory sd) = feed.staticcall(abi.encodeWithSignature("getOrigin()"));   // EOA address
        (bool success, bytes memory og) = feed.delegatecall(abi.encodeWithSignature("getOrigin()"));   // EOA address
         
        require(success);
        return (abi.decode(og, (address)));
    }
    
    
    function getAddress() public returns(address){ 
        // (bool success, bytes memory sd) = feed.staticcall(abi.encodeWithSignature("getAddress()")); // PriceFeed address
        (bool success, bytes memory ad) = feed.delegatecall(abi.encodeWithSignature("getAddress()")); // this contract address
         
        require(success);
        return (abi.decode(ad, (address)));
    }
    
    
    
    function setPrice(uint newPrice) view public {
        (bool success, bytes memory sd) = feed.staticcall(abi.encodeWithSignature("setPrice()", newPrice));
        
        require(success);
    }
    
}