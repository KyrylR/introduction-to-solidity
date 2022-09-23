const { accounts } = require("../scripts/helpers/utils.js");
const { assert } = require("chai");
const truffleAssert = require("truffle-assertions");
const { artifacts } = require("hardhat");

const ContractsHaterToken = artifacts.require("ContractsHaterToken");
const SimpleToken = artifacts.require("SimpleToken");


describe("ContractsHaterToken", () => {
    let SECOND, CHT;
    const RANDOM_ADDRESS = "0xa000000000000000000000000000000000000000";

    before("setup()", async () => {
        SECOND = await accounts(1);
        CHT = await ContractsHaterToken.new();
    });

    describe("decimals()", () => {
        it("should return correct decimals (18) for ContractsHaterToken", async () => {            
            assert.equal(await CHT.decimals(), "18");            
        });
    });

    describe("getAddress()", () => {
        it("should return correct address for ContractsHaterToken", async () => {
            assert.equal(await CHT.getAddress(), CHT.address);            
        });
    });

    describe("addToWhitelist(address)", () => {
        it("should add address to the whitelist if the owner requests it", async () => {
            await truffleAssert.passes(CHT.addToWhitelist(SECOND));
        });

        it("should NOT add address to the whitelist if NOT the owner requests it", async () => {
            await truffleAssert.reverts(CHT.addToWhitelist(SECOND, { from: SECOND }));
        });
    });

    describe("removeFromWhitelist(address)", () => {
        it("should remove address from the whitelist if the owner requests it", async () => {
            await truffleAssert.passes(CHT.removeFromWhitelist(SECOND));
        });

        it("should NOT remove address from the whitelist if NOT the owner requests it", async () => {
            await truffleAssert.reverts(CHT.removeFromWhitelist(SECOND, { from: SECOND }));
        });
    });

    // describe("isContract(address)", () => {
    //     it("should return true if it is contract's address", async () => {
    //         assert.equal(await CHT.isContract(CHT.address), "true");
    //     });

    //     it("should return false if it is NOT contract's address", async () => {
    //         assert.equal(await CHT.isContract(RANDOM_ADDRESS), "false");
    //     });
    // });

    describe("_beforeTokenTransfer(address,address,uint256)", () => {
        it("should allow mint", async () => {
            await truffleAssert.passes(CHT.mint(CHT.address, "100"));
            assert.equal(await CHT.balanceOf(CHT.address), "100")
        });

        it("should allow burn", async () => {
            await truffleAssert.passes(CHT.mint(SECOND, "100"));
            await truffleAssert.passes(CHT.burn("50", { from: SECOND }));
            assert.equal(await CHT.balanceOf(SECOND), "50");
        });

        it("should allow transfer tokens on its own address", async () => {
            const cht_ = await ContractsHaterToken.new();
            await truffleAssert.passes(await cht_.mint(SECOND, "100"));
            await truffleAssert.passes(await cht_.transfer(cht_.address, "20", { from: SECOND }));
            assert.equal(await cht_.balanceOf(SECOND), "80");
        });

        it("should revert if reciver is contract's address", async () => {
          const st1 = await SimpleToken.new("SimpleToken", "ST");
          const cht_ = await ContractsHaterToken.new();
          await truffleAssert.passes(await cht_.mint(SECOND, "100"));
          await truffleAssert.reverts(cht_.transfer(st1.address, "20", { from: SECOND }));
          assert.equal(await cht_.balanceOf(SECOND), "100");
        });

        it("should NOT revert if reciver is contract's address and is in whitelist", async () => {
            const st1 = await SimpleToken.new("SimpleToken", "ST");
            const cht_ = await ContractsHaterToken.new();
            await truffleAssert.passes(cht_.mint(SECOND, "100"));
            await truffleAssert.passes(cht_.addToWhitelist(st1.address));
            await truffleAssert.passes(cht_.transfer(st1.address, "20", { from: SECOND }));
            assert.equal(await cht_.balanceOf(SECOND), "80");
        });

        it("should NOT revert if reciver is NOT contract's address", async () => {
            const cht_ = await ContractsHaterToken.new();
            await truffleAssert.passes(cht_.mint(SECOND, "100"));
            await truffleAssert.passes(cht_.transfer(RANDOM_ADDRESS, "20", { from: SECOND }));
            assert.equal(await cht_.balanceOf(SECOND), "80");
        });
    });

});

