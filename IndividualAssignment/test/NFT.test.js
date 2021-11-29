const { assert, expect } = require('chai')
const { ethers } = require('hardhat')


describe('RainforestNFT', async function () {
    // contract instance
    let NFTInstance

    // addresses
    let owner
    let addr1
    let addr2
    let addr3

    // init tests
    before(async () => {
        // setup accounts
        [owner, addr1, addr2, addr3] = await ethers.getSigners() 

        // deploy contract instance
        const RainforestNFT = await ethers.getContractFactory("RainforestNFT")
        NFTInstance = await RainforestNFT.deploy()

        // mint some tokens
        for (let i = 1; i <= 5; i++) {
            await NFTInstance.mintNFT(owner.address);
        }
    })


    it('owner should be deployer', async () => {
        expect(await NFTInstance.owner()).to.equal(owner.address)
    })


    it('balance of owner should be 5 now', async () => {
        // balanceOf function need to be parse to Int
        balance = await NFTInstance.balanceOf(owner.address)
        expect(parseInt(balance)).to.equal(5)
    })
    

    it('owner of token 1 should be owner now', async () => {
        // get owner address of token 1
        expect(await NFTInstance.ownerOf(1)).to.equal(owner.address)
    })


    it('safe transfer token 2 from owner to addr1 should pass', async () => {
        await NFTInstance.safeTransfer(owner.address, addr1.address, 2)
        expect(await NFTInstance.ownerOf(2)).to.equal(addr1.address)
    })


    it('safe transfer token 3 from owner to addr1 with data should pass', async () => {
        await NFTInstance.safeTransferData(owner.address, addr1.address, 3, 1)
        expect(await NFTInstance.ownerOf(3)).to.equal(addr1.address)
    })


    it('transfer of token 1 from owner to addr1 should pass', async () => {
        // call safeTransferFrom with owner account
        await NFTInstance.transferFrom(owner.address, addr1.address, 1)
        // addr1 now owns token 1
        expect(await NFTInstance.ownerOf(1)).to.equal(addr1.address)
    })


    it('addr1 should be able to approve the transfer of token 1', async () => {
        await NFTInstance.connect(addr1).approve(addr2.address, 1)
        // addr1 owns token1
        expect(await NFTInstance.ownerOf(1)).to.equal(addr1.address)
        // addr2 got approved for the access to token 1
        expect(await NFTInstance.getApproved(1)).to.equal(addr2.address)
    })


    it('owner should be able to approve access to all tokens for addr3', async () => {

        // expect to have ApprovalForAll event emit
        expect(await NFTInstance.connect(owner).setApprovalForAll(addr3.address, true))
        .to.emit(NFTInstance, "ApprovalForAll")
        .withArgs(owner.address, addr3.address, true)

    })


    it('addr2 should be approved by addr1 for token 1', async () => {

        // expected this to emit approval event
        expect(await NFTInstance.connect(addr1).approve(addr2.address, 2))
        .to.emit(NFTInstance, "Approval")
        .withArgs(addr1.address, addr2.address, 2)

        // test approved token
        expect(await NFTInstance.getApproved(2)).to.equal(addr2.address)

    })


    it('isApprovedForAll to proof addr3 have the access to all owner\'s token', async () => {
        expect(await NFTInstance.isApprovedForAll(owner.address, addr3.address)).to.equal(true)
    })


    it('_transfer function should emit Transfer event', async () => {

        // expected this to emit Transfer event
        expect(await NFTInstance.connect(addr2).transferFrom(addr1.address ,addr3.address, 2))
        .to.emit(NFTInstance, "Transfer")
        .withArgs(addr1.address, addr3.address, 2)

        // test approved token
        expect(await NFTInstance.ownerOf(2)).to.equal(addr3.address)

    })


    // erc-165 interface id: 0x01ffc9a7
    it('supports ERC-165 Interface', async () => {
        expect(await NFTInstance.supportsInterface(0x01ffc9a7)).to.equal(true)
    })



})

