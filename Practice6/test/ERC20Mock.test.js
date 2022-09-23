
const { accounts } = require("../scripts/helpers/utils.js");
const { assert } = require("chai");
const { artifacts } = require("hardhat");

const ERC20Mock = artifacts.require("ERC20Mock");


describe("ERC20Mock", () => {
    let SECOND;

    before("setup()", async () => {
        SECOND = await accounts(1);
    });

    describe("decimals()", () => {
        it("should return correct decimals", async () => {
            const erc20 = await ERC20Mock.new("Token", "T", 18);
            
            assert.equal(await erc20.decimals(), "18");            
        });
    });

    describe("mint(address, uint256)", () => {
        it("should mint", async () => {
            const erc20 = await ERC20Mock.new("Token", "T", 18);
            
            await erc20.mint(SECOND, "100");

            assert.equal(await erc20.balanceOf(SECOND), "100");
        });
    });

    describe("burn(uint256)", () => {
        it("should burn", async () => {
            const erc20 = await ERC20Mock.new("Token", "T", 18);
            
            await erc20.mint(SECOND, "100");
            await erc20.burn(SECOND, "50")

            assert.equal(await erc20.balanceOf(SECOND), "50");
        });
    });

});

