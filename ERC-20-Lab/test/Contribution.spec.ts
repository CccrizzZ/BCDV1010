import hre, { artifacts, ethers } from "hardhat";
import type { SignerWithAddress } from "@nomiclabs/hardhat-ethers/dist/src/signer-with-address";
import { expect } from "chai";
import { Artifact } from "hardhat/types";
import type { Contribution, GBCToken } from "../typechain";
import { Signers } from "./types";

export async function getBlockTimestamp(): Promise<number> {
  const blockNumber = await hre.ethers.provider.getBlockNumber();
  const block = await hre.ethers.provider.getBlock(blockNumber);
  const timestamp = block.timestamp;
  return timestamp;
}

describe("GBC Token", function () {
  before(async function () {
    this.signers = {} as Signers;
    const signers: SignerWithAddress[] = await hre.ethers.getSigners();
    this.signers.admin = signers[0];
    this.signers.alice = signers[1];
    this.signers.bob = signers[2];
    const GBCTokenArtifact: Artifact = await artifacts.readArtifact("GBCToken");
    const ContributionArtifact: Artifact = await artifacts.readArtifact(
      "Contribution"
    );
    this.startTime = (await getBlockTimestamp()) + 1;
    this.endTime = this.startTime + 2000000;
    this.totalSupply = "100000000000000000000";
    this.symbol = "GBC";
    this.name = "GBC Token";
    this.gbcToken = <GBCToken>(
      await hre.waffle.deployContract(this.signers.admin, GBCTokenArtifact, [
        this.startTime,
        this.endTime,
        this.name,
        this.symbol,
        this.totalSupply,
      ])
    );
    this.contribution = <Contribution>(
      await hre.waffle.deployContract(
        this.signers.admin,
        ContributionArtifact,
        [this.gbcToken.address]
      )
    );
    await this.gbcToken.approve(this.contribution.address, this.totalSupply);
  });

  describe("Should pass", function () {
    it("sets token contract", async function () {
      expect(await this.contribution._tokenContract()).to.equal(
        this.gbcToken.address
      );
    });
    it("donate", async function () {
      expect(
        await this.signers.alice.sendTransaction({
          to: this.contribution.address,
          value: ethers.BigNumber.from("1000000000000000000"),
        })
      ).emit(this.contribution, "Contribute");
      expect(
        await this.gbcToken.balanceOf(this.signers.alice.address)
      ).to.equal("1000000000000000000");
      expect(
        await this.gbcToken.balanceOf(this.signers.admin.address)
      ).to.equal("99000000000000000000");
      expect(
        await this.contribution.getAmountOfEthContributed(
          this.signers.alice.address
        )
      ).to.equal("1000000000000000000");
    });
  });
});