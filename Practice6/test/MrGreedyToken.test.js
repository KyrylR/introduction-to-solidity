const { accounts } = require("../scripts/helpers/utils.js");
const { assert } = require("chai");
const truffleAssert = require("truffle-assertions");
const { artifacts } = require("hardhat");

const MrGreedyToken = artifacts.require("MrGreedyToken");


describe("MrGreedyToken", () => {
    let SECOND, MRG;
    const RANDOM_ADDRESS = "0xa000000000000000000000000000000000000000";
    const TREASURY = "0xD000000000000000000000000000000000000000";
    const ONE_TOKEN = 10 ** 6;

    before("setup()", async () => {
        SECOND = await accounts(1);
        MRG = await MrGreedyToken.new();
    });

    describe("decimals()", () => {
        it("should return correct decimals (6) for MrGreedyToken", async () => {            
            assert.equal(await MRG.decimals(), "6");            
        });
    });

    describe("getAddress()", () => {
        it("should return correct address for MrGreedyToken", async () => {
            assert.equal(await MRG.getAddress(), MRG.address);            
        });
    });

    describe("treasury()", () => {
        it("should return correct treasury address for MrGreedyToken", async () => {
            assert.equal(await MRG.treasury(), TREASURY);            
        });
    });

    describe("getResultingTransferAmount(uint256)", () => {
        it("should return the correct number of tokens that the recipient will receive.", async () => {
            assert.equal(await MRG.getResultingTransferAmount(100 * ONE_TOKEN), 90 * ONE_TOKEN);            
        });

        it("should return 0 if number of tokens is less then fee.", async () => {
            assert.equal(await MRG.getResultingTransferAmount(5 * ONE_TOKEN), 0);            
        });
    });

    describe("transfer(address,uint256)", () => {
        it("should transfer all tokens to the treasury if their number are less then fee", async () => {
            const mrg_ = await MrGreedyToken.new();
            await truffleAssert.passes(await mrg_.mint(SECOND, 100 * ONE_TOKEN));
            await truffleAssert.passes(await mrg_.transfer(RANDOM_ADDRESS, 5 * ONE_TOKEN, { from: SECOND }));
            assert.equal(await mrg_.balanceOf(SECOND), 95 * ONE_TOKEN);
            assert.equal(await mrg_.balanceOf(RANDOM_ADDRESS), 0 * ONE_TOKEN);
            assert.equal(await mrg_.balanceOf(TREASURY), 5 * ONE_TOKEN);
        });

        it("should transfer fee tokens to the treasury if number of transfer tokens is more then fee", async () => {
            const mrg_ = await MrGreedyToken.new();
            await truffleAssert.passes(await mrg_.mint(SECOND, 100 * ONE_TOKEN));
            await truffleAssert.passes(await mrg_.transfer(RANDOM_ADDRESS, 51 * ONE_TOKEN, { from: SECOND }));
            assert.equal(await mrg_.balanceOf(SECOND), 49 * ONE_TOKEN);
            assert.equal(await mrg_.balanceOf(RANDOM_ADDRESS), 41 * ONE_TOKEN);
            assert.equal(await mrg_.balanceOf(TREASURY), 10 * ONE_TOKEN); 
        });
    });
});
