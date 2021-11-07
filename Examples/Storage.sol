// SPDX-License-Identifier: MIT

pragma solidity ^0.8.6;

error Unauthorized();
error UnauthorizedSet(uint256);
error UnauthorizedIncrement();
error UnauthorizedIncrementWithNumber(uint256);
error UnauthorizedDecrement();
error UnauthorizedDecrementWithNumber(uint256);

contract SimpleStorage {
  uint8 storedData;
  address owner;

  // create event
  event Set(address indexed caller, uint8 indexed storedData);
  event Increment(address indexed caller, uint8 indexed storedData, uint8 indexed incrementValue);
  event Decrement(address indexed caller, uint8 indexed storedData, uint8 indexed decrementValue);

  // create new struct
  struct Member {
    string name;
    bool isWhiteListed;
  }

  // map of custom struct
  mapping(address => Member) whiteListed;


  // contract constructor
  constructor(uint8 $x, string memory $name) {
    assert($x > 0);
    storedData = $x;
    
    // set owner to contract deployer
    owner = msg.sender;

    // white list the owner
    whiteListed[msg.sender].isWhiteListed = true;
    whiteListed[msg.sender].name = $name;

  }


  // get white listed account
  function getWhitelisted(address $account) public view returns(Member memory){
    return whiteListed[$account];
  }


  // set white listed account
  function setWhitelisted(address $account, string memory $name) public  {
    
    // throw error if owner is not sender
    if (owner != msg.sender) {
      revert Unauthorized();
    }

    // set account to be white listed
    whiteListed[$account].name = $name;
    whiteListed[$account].isWhiteListed = true;

  }

  // set white listed account overload
  function setWhitelisted(address $account, Member memory $member) public  {
    
    // throw error if owner is not sender
    if (owner != msg.sender) {
      revert Unauthorized();
    }

    // set member to be white listed
    require($member.isWhiteListed, "cannot unset");
    whiteListed[$account] = $member;
  }
  
  // unset white listed account
  function unsetWhitelisted(address $account) public  {
  
    // throw error if owner is not sender
    if (owner != msg.sender) {
      revert Unauthorized();
    }

    // make sure the account is the deployer and remove from white list
    require(owner != $account, "you cannot black list user");
    whiteListed[$account].isWhiteListed = false;

  }


  function set(uint8 $x) public {
    if(owner != msg.sender) {
      revert UnauthorizedSet($x);
    }

    storedData = $x;

    emit Set(msg.sender, storedData);

  }

  function get() public view returns(uint8){
    return storedData;
  }

  function add(uint256 $a, uint256 $b) public pure returns(uint256){
    return $a + $b;
  }






  // modifiers
  modifier onlyOwner(){
    require(owner == msg.sender, "Unauthorized");
    _;
  }

  modifier greaterThanZero(uint8 $x){
    require($x > 0, "number should be greater than zero");
    _;
  }

  modifier onlyWhitelisted(){
    require(whiteListed[msg.sender].isWhiteListed, "you are not white listed");
    _;
  }






  function _onlyOwner() private view {
    require(owner == msg.sender, "Unauthorized");
  }

  function increment(uint8 $x) public greaterThanZero($x) onlyWhitelisted() {

    storedData++;
    emit Increment(msg.sender, storedData, 1)

  }




}
