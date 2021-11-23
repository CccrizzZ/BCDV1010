
// address of other users account
// these are development network wallet I created in metamask
const friends = [
    "0xDD3C0c2fCba16BEC95c09af9F5040e93474577aE",
    "0x9E9e6Ffb87B0B5d8F39770544704e8862e2496e8",
    "0x55CFa30E55eF0E51b95cEBe566480a54E35e299a",
];

// address of existing NFT contract i deployed
const existingContractAddr = "0xB6a38d252b572d28c7F3edaBcc2dE5D4C4C81A87";

// mint function
async function main() {

  // grab the NFT contract
  const nft = await hre.ethers.getContractAt("CyberGarden", existingContractAddr);

  // get account 0 from the blockchain provider
  const signer0 = await ethers.provider.getSigner(0);

  // get the nounce from account 0
  const nonce = await signer0.getTransactionCount();

  // loop all friends account
  for(let i = 0; i < friends.length; i++) {

    // token json object URI uploaded to public free IPFS
    const tokenURI = "https://gateway.ipfs.io/ipfs/QmR4PEH7LPZb6eSd8Yiy46mzHQjAXAimm6UE2mfqgyPq94";
    

    // run the mint function on the NFT contract of mine
    // this sends the minted NFT to every account in the friends array
    await nft.awardItem(
      friends[i], 
      tokenURI,
      {nonce: nonce + i}
    );
  
  }

  console.log("Minting is complete!");
}


// run the main function
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
});