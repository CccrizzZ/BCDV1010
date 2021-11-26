 
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

/* A demo contract for token
 * Run the test as follows:
 * 1) create PriceFeed with account A
 * 2) create MetaCoin with account A
 * 3) Copy the address of account B
 * 4) run MetaCoin.sendCoin(account B, 100) with account A
 * 5) check MetaCoin.getBalance(account B) for balance of account B.
 * 6) check MetaCoin.getBalanceInEth(account B, 2) for balance in Eth.
 * 7) check MetaCoin.getBalance(account A) for balance of account A. 
 */

contract PriceFeed {
  uint private _price = 2;
  function getPrice() public view returns (uint) {
    return _price;
  }
  
  function setPrice(uint _price_) public {
      _price = _price_;
  }
}

library ConvertLib {
    function convert(uint _amount, uint _conversionRate) public pure returns (uint convertAmount) {
        return _amount * _conversionRate;
    }
}

contract MetaCoin {
    mapping(address => uint) public balances;
    
    event Transfer(address indexed _from, address indexed _to, uint indexed _amount);
    
    PriceFeed public feed;
    
    constructor(PriceFeed _feed) {
        feed = _feed;
        balances[msg.sender] = 10000;
    }
    
    function sendCoin(address _receiver, uint _amount) public returns(bool _sufficent) {
        balances[msg.sender] = balances[msg.sender] - _amount;
        balances[_receiver] = balances[_receiver] + _amount;
        emit Transfer(msg.sender, _receiver, _amount);
        _sufficent = true;
    }
    
    function getBalance(address _account) public view returns(uint _balance) {
        _balance = balances[_account];
    }
    
    function getBalanceInEth(address _account) public view returns(uint _balanceInEth) {
        uint _exchangeRate = feed.getPrice();
        _balanceInEth = ConvertLib.convert(balances[_account],_exchangeRate);
    }
}