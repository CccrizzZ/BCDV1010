import type { SignerWithAddress } from "@nomiclabs/hardhat-ethers/dist/src/signer-with-address";
import type { Fixture } from "ethereum-waffle";
import type { GBCToken, Contribution } from "../typechain";

export interface Signers {
  admin: SignerWithAddress;
  alice: SignerWithAddress;
  bob: SignerWithAddress;
}

declare module "mocha" {
  export interface Context {
    gbcToken: GBCToken;
    contribution: Contribution;
    signers: Signers;
    loadFixture: <T>(fixture: Fixture<T>) => Promise<T>;
  }
}