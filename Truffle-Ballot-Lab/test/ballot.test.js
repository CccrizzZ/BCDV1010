// require the compiled solidity contract from build folder 
const Ballot = artifacts.require("Ballot");
const truffleAssert = require("truffle-assertions");
const {assert, expect} = require("chai")


// // test target contract
contract("Ballot", (accounts) => {

    // initial deployment
    describe("Initial deployment", async () => {
        it("should assert true", async function(){
            // contract should be deployed successfully
            await truffleAssert.passes(Ballot.deployed())
            assert.isTrue(true)
            
        });
        
        it("should initialize the owner as the chairperson", async () => {

            // create contract instance
            let instance = await Ballot.deployed();

            // ensure that the contract owner is account [0]
            assert.equal(await instance.chairperson(), accounts[0])

        });
    });


    // registration function
    describe("Registration", () => {
        let BallotInstance;
        beforeEach(async () => {
            // get ballot
            BallotInstance = await Ballot.deployed()
        });

        it("will revert if non chairperson registers the voter", async () => {

            // revert should pass
            // this should fail because account 2 is not the charman
            await truffleAssert.reverts(
                BallotInstance.register(accounts[1], {from: accounts[2]}),
                // BallotInstance.register(accounts[1], {from: accounts[0]}),  // did not fail so error
                truffleAssert.ErrorType.REVERT,
                "only charman can register the voter", 
            )

        });

        it("chair person can register the voters", async () => {

            // ensure that chairman is able to register the voters
            await truffleAssert.passes(
                BallotInstance.register(accounts[2], {from: accounts[0]}),
                "char person can register the voters"
            )

        });
    });


    // state change function
    describe("Change State", () => {

        let BallotInstance;
        beforeEach(async () => {
            // get ballot
            BallotInstance = await Ballot.deployed()
        });

        it("will revert if non-chairperson changes the state", async () => {

            // this should get revert because account 2 is not chairman
            await truffleAssert.reverts(
                BallotInstance.changeState(2, {from: accounts[2]}),    // trying to change to vote state by account 2
                truffleAssert.ErrorType.REVERT,
                "only chairman can change the voting state"
            )

        });

        it("will revert when voter tries to vote during Reg state", async () => {
            
            // the default state is registration state
            // register the voter by the chairman
            await BallotInstance.register(accounts[2], {from: accounts[0]})

            // this should get revert because ballot is not in voting state
            await truffleAssert.reverts(
                BallotInstance.vote(5, {from: accounts[2]}),   // vote proposal number 5 from account 2
                truffleAssert.ErrorType.REVERT,
                "voters can only vote in voting state"
            )
        });

        it("chair person can change the state", async () => {

            // change the state to vote state by the chairman
            await truffleAssert.passes(
                BallotInstance.changeState(2, {from: accounts[0]}), 
                "only chairman can change the state"
            )
        });

        it("will revert if changeState() is supplied invalid state", async () => {

            // change to state 200 witch did not exist
            await truffleAssert.reverts(
                BallotInstance.changeState(200, {from: accounts[0]}),   
                truffleAssert.ErrorType.REVERT,
                "target state doesn't exist"
            )


            // change to state 0 witch is not allowed (state only increase)
            await truffleAssert.reverts(
                BallotInstance.changeState(0, {from: accounts[0]}),   
                truffleAssert.ErrorType.REVERT,
                "cant go back to previous state"
            )
        });
    });


    // vote function
    describe("Vote", () => {
        let BallotInstance;
        beforeEach(async () => {
            // get ballot
            BallotInstance = await Ballot.deployed()
        });

        it("Registered voters can vote", async () => {

            // assert ballot is in voting state
            assert.equal(await BallotInstance.CurrState(), 2)
            
            // account 2 is already registered above
            await truffleAssert.passes(
                BallotInstance.vote(5, {from: accounts[2]})
            )
        
        });
    });


    // determine winning proposal function
    describe("reqWinner", () => {

        let BallotInstance;
        beforeEach(async () => {
            // get ballot
            BallotInstance = await Ballot.deployed()
        });

        it("will revert when winner is requested if winningVoteCount is less than 3", async () => {
            
            // change state to done
            BallotInstance.changeState(3, {from: accounts[0]})

            // require winner
            await truffleAssert.reverts(
                BallotInstance.reqWinner(),
                truffleAssert.ErrorType.REVERT,
                "cant go back to previous state"
            )


        });
    });
});




contract("Ballot", function (accounts) {
    before(async function(){

        // contract state wont update??


        // deployment of Ballot should be successful
        await truffleAssert.passes(Ballot.deployed())
        assert.isTrue(true)
        
    });

    describe("Registration", () => {
        let BallotInstance;
        beforeEach(async () => {
            // get ballot
            BallotInstance = await Ballot.deployed()
        });

        it("chair person can register multiple voters", async () => {

            // ensure that current state is resgistration state
            assert.equal(await BallotInstance.CurrState(), 1)

            // ensures that the charman can register multiple volters
            await BallotInstance.register(accounts[1], {from: accounts[0]})
            await BallotInstance.register(accounts[2], {from: accounts[0]})
            await BallotInstance.register(accounts[3], {from: accounts[0]})

        });
    });

    describe("Vote", () => {
        let BallotInstance;
        beforeEach(async () => {
            // get ballot
            BallotInstance = await Ballot.deployed()
        });

        it("Multiple registered voters can vote", async () => {
            
            // change state to voting stat
            await BallotInstance.changeState(2, {from: accounts[0]})
            
            // ensure that current state is resgistration state
            assert.equal(await BallotInstance.CurrState(), 2)

            // mutiple voting
            await BallotInstance.vote(5, {from: accounts[1]})
            await BallotInstance.vote(5, {from: accounts[2]})
            await BallotInstance.vote(5, {from: accounts[3]})


        });

        it("Should revert when voted user tries to vote again", async () => {
            
            // account 4 voted
            await BallotInstance.vote(5, {from: accounts[4]}),
            
            // require winner
            await truffleAssert.reverts(
                BallotInstance.vote(5, {from: accounts[4]}),
                truffleAssert.ErrorType.REVERT,
                "cant vote if already voted"
            )
            
        });

        it("Should revert when voter tires to vote for invalid proposal", async () => {
            
            // require winner
            await truffleAssert.reverts(
                BallotInstance.vote(200, {from: accounts[1]}),
                truffleAssert.ErrorType.REVERT,
                "cant vote for invalid proposal"
            )

        });

    });

    describe("reqWinner", () => {
        let BallotInstance;
        beforeEach(async () => {
            // get ballot
            BallotInstance = await Ballot.deployed()
        });

        it("Get winners after voting state is Done", async () => {

            // three accounts voted above, it is able to get the winner

            // chairman change the state to Done state
            await BallotInstance.changeState(3, {from: accounts[0]})
                
            // require winner
            await truffleAssert.passes(
                await BallotInstance.reqWinner(),
                "getting the winner"
            )

        });
    });

});
