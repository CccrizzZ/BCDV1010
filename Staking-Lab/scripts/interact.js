// interact.js

const API_KEY = process.env.API_KEY;
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const CONTRACT_ADDRESS = process.env.CONTRACT_ADDRESS;
const EXTERNAL_CONTRACT_ADDRESS = process.env.EXTERNAL_CONTRACT_ADDRESS;


// provider - Alchemy
const alchemyProvider = new ethers.providers.AlchemyProvider(network="rinkeby", API_KEY);


// contract abis
const stakerContract = require("../artifacts/contracts/Staker.sol/Staker.json");
const externalContract = require("../artifacts/contracts/Staker.sol/ExampleExternalContract.json");

// signer - rinkeby metamask wallet
const signer = new ethers.Wallet(PRIVATE_KEY, alchemyProvider);

// contract instances
const StakerContract = new ethers.Contract(CONTRACT_ADDRESS, stakerContract.abi, signer);
const ExampleExternalContract = new ethers.Contract(EXTERNAL_CONTRACT_ADDRESS, externalContract.abi, signer);




async function main() {

    // test example external contract
    const notCompleted = await ExampleExternalContract.notCompleted()
    console.log(`ExternalContract----completed ${notCompleted}`)

    const ExternalContractBalance = await ExampleExternalContract.getContractBalance()
    console.log(`ExternalContract----balance ${ExternalContractBalance}`)



    // test staker contract
    const timeLeft = await StakerContract.timeLeft()
    console.log(`StakerContract----timeleft ${timeLeft}`)


}

main();