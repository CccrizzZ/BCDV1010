// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import “GBCToken.sol”;

contract DEX {

    IERC20 public token;

    event Bought(uint256 amount);
    event Sold(uint256 amount);

    constructor() public {
        token = new StandardERC20Token();
    }
    
    function buy() payable public {
        // TODO
    }
    
    function sell(uint256 amount) public {
        // TODO
    }

}