// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

contract Ballot {
    
    // voter struct
    struct Voter {
      uint weight;
      bool voted;
      uint vote;
    }
    
    // proposal struct
    struct Proposal{
        uint voteCount;
    }

    // chairman address
    address public chairperson;
    
    // mapping for all voter address
    mapping(address => Voter) public voters;

    // array of proposal
    Proposal[] public proposals; 
    

    // phase of voting
    // 0 - Init: initialize
    // 1 - Regs: voter registration (by chairman)
    // 2 - Vote: voter votes 
    // 3 - Done: finish voting
    enum Phase {Init, Regs, Vote, Done}
    
    // current phase
    Phase public CurrState = Phase.Done;
    

    constructor (uint numProposals){

        // set the chairperson to the deployer
        chairperson = msg.sender;
        
        // default weight for chairman is 2
        voters[chairperson].weight = 2;
        
        // push all proposals to the proposals array
        for(uint prop = 0 ; prop < numProposals ; prop++){
            // Proposal memory p;
            // p.voteCount = 0;
            // OR
            // Proposal memory p = Proposal(0);
            // proposals.push(p);
            // OR
            proposals.push(Proposal(0));
        }

        // set current state to registration state
        CurrState = Phase.Regs;
    }
    

    // modifier that makesure the function caller is the chairperson
    modifier onlyChair() {
        require(msg.sender  == chairperson,"you are not chairperson");
        _;
    }
    

    // modifier that validates the current phase of voting
    modifier validPhase(Phase reqPhase) {
        require(CurrState == reqPhase);
        _;
    }
    





    // change current voting state (only chairman can change state)
    function changeState(Phase x) public onlyChair {
        require(x > CurrState);
        CurrState = x;
    }
    

    // register voters (must be in registration state)
    function register(address voter) public validPhase(Phase.Regs) onlyChair {
        // if voter voted cant register
        require(voters[voter].voted == false);
        // default weight for voter is 1
        voters[voter].weight = 1;
    }
    

    // register voters (must be in registration state)
    function vote(uint toProposal) public validPhase(Phase.Vote) {
        
        // store the voter in the memory
        Voter memory sender = voters[msg.sender];
        
        // ensure the caller never voted
        require(sender.voted == false);
        
        // ensure the proposal exist in the array
        require(toProposal < proposals.length);
        
        // set the target voter voted
        voters[msg.sender].voted = true;

        // set the target voter's voted proposal to be the target proposal
        voters[msg.sender].vote = toProposal;

        // add voter's weight to the target proposal in the proposal array
        proposals[toProposal].voteCount += sender.weight;
    }
    

    // determine witch proposal is the winner (must be in Done state)
    function reqWinner() public validPhase(Phase.Done) view returns(uint) {
        
        // vote count and wining proposal
        uint winningVoteCount = 0;
        uint winningProposal = 0;

        // iterate all proposals
        for(uint prop = 0 ; prop < proposals.length ; prop++) {

            // load the proposal with the most vote into the winning proposal variable
            if(proposals[prop].voteCount > winningVoteCount) {
                winningVoteCount = proposals[prop].voteCount;
                winningProposal = prop;
            }
        }

        // winning vote must be more than 3
        assert(winningVoteCount >= 3);

        // return the winning proposal
        return winningProposal;
    }
}