const { accounts } = require("../scripts/helpers/utils.js");
const { assert } = require("chai");
const truffleAssert = require("truffle-assertions");
const { artifacts } = require("hardhat");

const SimpleToken = artifacts.require("SimpleToken");


describe("SimpleToken", () => {
    let SECOND;

    before("setup()", async () => {
        SECOND = await accounts(1);
    });

    describe("decimals()", () => {
        it("should return correct decimals (18) for SimpleToken", async () => {
            const simpleToken = await SimpleToken.new("SimpleToken", "ST");
            
            assert.equal(await simpleToken.decimals(), "18");            
        });
    });

    describe("getAddress()", () => {
        it("should return correct address for SimpleToken", async () => {
            const simpleToken = await SimpleToken.new("SimpleToken", "ST");
            
            assert.equal(await simpleToken.getAddress(), simpleToken.address);            
        });
    });

    describe("mint(address, uint256)", () => {
        it("should mint if the owner requests it", async () => {
            const simpleToken = await SimpleToken.new("SimpleToken", "ST");
            
            await simpleToken.mint(SECOND, "100");

            assert.equal(await simpleToken.balanceOf(SECOND), "100");
        });

        it("should NOT mint if NOT the owner requests it", async () => {
            const simpleToken = await SimpleToken.new("SimpleToken", "ST");
            
            await truffleAssert.reverts(simpleToken.mint(SECOND, "100", { from: SECOND }), "Ownable: caller is not the owner");

            assert.equal(await simpleToken.balanceOf(SECOND), "0");
        });
    });

    describe("burn(uint256)", () => {
        it("should burn if the holder requests it", async () => {
            const simpleToken = await SimpleToken.new("SimpleToken", "ST");
            
            await simpleToken.mint(SECOND, "100");
            await simpleToken.burn("50", { from: SECOND })

            assert.equal(await simpleToken.balanceOf(SECOND), "50");
        });

        it("should NOT burn if NOT the holder requests it(number of tokens on someone account is not enough)", async () => {
            const simpleToken = await SimpleToken.new("SimpleToken", "ST");
            
            await simpleToken.mint(SECOND, "100");
            assert.equal(await simpleToken.balanceOf(simpleToken.address), "0")
            await truffleAssert.reverts(simpleToken.burn("50"), "ERC20: burn amount exceeds balance");

            assert.equal(await simpleToken.balanceOf(SECOND), "100");
        });
    });

});

