
// this function deploys the NFT contract to DApps host (alchemy infura)
async function main() {

    // grab the NFT contract
    const CyberGarden = await hre.ethers.getContractFactory("CyberGarden");
    
    // deploy the contract with await 
    const nft = await CyberGarden.deploy();
  
    // confirm deployment
    await nft.deployed();
    
    // log the address of the deployed contract
    console.log("CyberGarden deployed to:", nft.address);
}


// CyberGarden deployed to
// ropsten: 0xB6a38d252b572d28c7F3edaBcc2dE5D4C4C81A87
// rinkeby: 0xB6a38d252b572d28c7F3edaBcc2dE5D4C4C81A87



// run the main function
main()
.then(() => process.exit(0))
.catch((error) => {
    console.error(error);
    process.exit(1);
});