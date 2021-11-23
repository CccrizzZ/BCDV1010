// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";


// this is the GBC token contract
// inherits from ERC20
contract GBCToken is ERC20, Ownable {

    // variables have to declare public for hardhat to detect
    // start and end time for transfering GBC tokens
    uint256 public startTime;
    uint256 public endTime;



    constructor(uint256 _startTime, uint256 _endTime, string memory _name, string memory _symbol, uint256 _totalSupply) ERC20(_name, _symbol) payable {

        // set start and end time
        startTime = _startTime;
        endTime = _endTime;

        
        // mint token of totalSupply, minted token goes into the owner's account
        _mint(msg.sender, _totalSupply);

    }


    // modifier that require the transaction to be in time limit
    modifier limitedTime{
        require(block.timestamp >= startTime && block.timestamp <= endTime, "Token sale has ended");
        _;
    }


    // override the ERC-20 function with a requirment of time limit implemented
    function transfer(address recipient, uint256 amount) public virtual override limitedTime returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }
    

    // issue token to contributor function for external contract
    function issueToken(address recipient, uint256 amount) external limitedTime returns (bool){
        _transfer(owner(), recipient, amount);
        return true;
    }


}





// this contract holds donation in eth
// and issues donator GBCTokens
contract Contribution {


    // owner of this contract
    address owner;

    // GBCToken address
    address public _tokenContract;

    // mapping for contributors => amount of donation in wei
    mapping(address => uint256) public AllContributors;
    
    // total contribution amount in eth/wei
    uint256 public totalContributionAmount;

    // numbers of contributors
    uint256 public NumberOfContributors;

    // contribute event
    event Contribute(address contributor, uint256 amount);


    constructor(address GBCTokenAddress){
        // set the address of GBCToken
        _tokenContract = GBCTokenAddress;

        // set owner
        owner = msg.sender;
    }




    // get how many contributors donated
    function getContributorCount() public view returns(uint256) {
        return NumberOfContributors;
    }


    // get total eth donated
    function getTotalContributionInEth() public view returns(uint256) {
        return totalContributionAmount / 10 ** 18;
    }


    // get total amount of donation from a specific address
    function getAmountOfEthContributed(address target) external view returns(uint256) {
        return AllContributors[target];
    }




    fallback() payable external {}
    receive() payable external {

        // make sure transfer amount is not 0
        require(msg.value > 0, "transfer must be greater than 0");

        // increment contribution amount of that address
        AllContributors[msg.sender] += msg.value;

        // increment total contribution amount
        totalContributionAmount += msg.value;

        // increment NumberOfContributors
        NumberOfContributors++;

        // send the contributor GBCTokens
        GBCToken(_tokenContract).issueToken(msg.sender, msg.value);
        
        // emit the contribution event
        emit Contribute(msg.sender, msg.value);
    }


}


