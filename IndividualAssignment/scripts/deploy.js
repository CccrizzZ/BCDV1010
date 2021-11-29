
// this function deploys the NFT contract to DApps host (alchemy infura)
async function main() {

    // grab the NFT contract
    const RainforestNFT = await hre.ethers.getContractFactory("RainforestNFT");
    
    // deploy the contract with await 
    const nft = await RainforestNFT.deploy();
  
    // confirm deployment
    await nft.deployed();
    
    // log the address of the deployed contract
    console.log("NFT contract deployed to:", nft.address);
}

// contract address:
// rinkeby: 



// run the main function
main()
.then(() => process.exit(0))
.catch((error) => {
    console.error(error);
    process.exit(1);
});