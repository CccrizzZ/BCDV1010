async function main() {

    // deploy example external contract
    const ExampleContract = await ethers.getContractFactory("ExampleExternalContract");
    const examplecontract = await ExampleContract.deploy();   
    console.log("ExampleContract deployed to address:", examplecontract.address);


    // deploy staker contract
    const Staker = await ethers.getContractFactory("Staker");
    const staker = await Staker.deploy(examplecontract.address);   
    console.log("StakerContract deployed to address:", staker.address);

}

main()
.then(() => process.exit(0))
.catch(error => {
    console.error(error);
    process.exit(1);
});