// SPDX-License-Identifier:MIT
pragma solidity ^0.8.6;


contract ExampleExternalContract {

    bool public completed;

    // called by staker contract
    function complete() public payable {
        completed = true;
    }

    // get the balance of this contract 
    function getContractBalance() public view returns(uint256) {
        return address(this).balance;
    }



    function notCompleted() external view returns(bool) {
        return !completed;
    }
}









// this contract takes eth from all stakers and keep track of their balance
contract Staker {

    // pointer to exampleExternalContract
    ExampleExternalContract public exampleExternalContract;

    // threshold is always 1 ether
    uint256 public constant threshold = 1 ether;

    // mapping that tracks all stakers's fund staked here
    mapping ( address => uint256 ) public balances;

    // deadline for execute()
    uint256 public deadline;
    
    // if passed the dead line and the balance is less than threshold this will be set to true
    bool public openForWithdraw;

    // stake event emmited when stake() executed
    event stakeEvent(address from, uint256 amount);




    // constructor takes target example contract address
    constructor(address exampleExternalContractAddress) {

        // create new pointer
        exampleExternalContract = ExampleExternalContract(exampleExternalContractAddress);

        // set the deadline
        deadline = block.timestamp + 30 seconds;
    }
    


    // ensure the balance is greater than 0
    modifier isDeposited{
        require(balances[msg.sender] > 0, "make sure you deposited");
        _;
    }

    modifier requireNotExecuted{
        // require not executed
        require(exampleExternalContract.notCompleted(), "already completed! execute already called");
        _;
    }

    modifier onlyAfterDeadLine{
        // require time passed deadline
        require(block.timestamp >= deadline, "can only execute after deadline");
        _;
    
    }

    modifier onlyBelowThreshold(){
        require(address(this).balance < threshold, "can only be called if balance less than threshold");
        openForWithdraw = true;
        _;  
    }



    // the stake function
    function stake() public payable requireNotExecuted {

        // require amount to be greater than 0
        require(msg.value > 0, "stake amount should be greater than 0");

        // require only before deadline
        require(block.timestamp < deadline, "can only execute before deadline");

        // record stake amount and address
        balances[msg.sender] += msg.value;

        // emit event
        emit stakeEvent(msg.sender, balances[msg.sender]);

    }



    // After some `deadline` allow anyone to call an `execute()` function
    function execute() public isDeposited requireNotExecuted onlyAfterDeadLine{
        
        // require deposited amount to be greater than threshold
        require(address(this).balance >= threshold, "contract balance must be greater than threshold");

        // send all balance to external contract
        exampleExternalContract.complete{value: address(this).balance}();
    }



    // if the `threshold` was not met, allow everyone to call a `withdraw()` function
    function withdraw() public isDeposited requireNotExecuted onlyBelowThreshold{

        // ensure the balance is less than the threshold
        require(address(this).balance < threshold, "can only becalled when balance less than threshold");

        // send the balance back to the user
        payable(msg.sender).transfer(balances[msg.sender]);


    }



    // Add a `timeLeft()` view function that returns the time left before the deadline for the frontend
    function timeLeft() public view returns(uint256){
        
        // if deadline already passed return 0
        if(block.timestamp >= deadline) return 0;

        // return the time left before the deadline
        return deadline - block.timestamp;
    }



    // Add the `receive()` special function that receives eth and calls stake()
    receive() payable external {
        this.stake();
    }


    // get how much staked of certain account
    function getContractBalance() public view returns(uint256){
        return address(this).balance;
    }

}




//  Checklist
//  Do you see the balance of the Staker contract go up when you stake()?
//  yes
//  Is your balance correctly tracked?
//  yes
//  Do you see the events logs in the transaction receipt?
//  yes
//  Can you query timeLeft while you trigger a transaction within dev IDE environment?
//  yes
//  If you stake() enough ETH before the deadline, does it call complete()?
//  yes
//  If you don't stake() enough can you withdraw(address payable) your funds?
//  yes
//  Make sure funds can't get trapped in the contract! Try sending funds after you have executed!
//  done

//  Try to create a called notCompleted. It will check that ExampleExternalContract is not 
//  completed yet. Use it to protect your execute and withdraw functions.
//  done

//  Submit the answers for the following questions along the contract url link.



//  Can execute get called more than once, and is that okay?
//  no, the example contract prevented it, it depends on the purpose of the deadline and the target external contract weather its ok or not

//  Can you deposit and withdraw freely after the deadline, and is that okay?
//  I can withdraw but not deposite, it is not ok to deposite because if the balance passed threshold withdraw cannot becalled

//  What are other implications of anyone being able to withdraw for someone?
//  the other guy will steal all the assets if combination of their assets is less than threshold and the dead line is passed
//  I prevented it by making withdraw function only spit out what the sender has put in

//  Can you implement your own that checks whether deadline was passed or not? Where can you use it?
//  yes I can, by using a modifier that compares block.timestamp and deadline
//  I can use it on withdraw(), execute()