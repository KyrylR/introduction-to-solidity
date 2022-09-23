
const { accounts } = require("../scripts/helpers/utils.js");
const { assert } = require("chai");
const { artifacts } = require("hardhat");

const ERC20Mock = artifacts.require("ERC20Mock");

const DATA = {
    name: "Token",
    symbol: "T",
    decimals: 18,
    mint: "100"
}


describe("ERC20Mock", () => {
    let SECOND;

    before("setup()", async () => {
        SECOND = await accounts(1);
    });

    describe("decimals()", () => {
        it("should return correct decimals", async () => {
            const erc20 = await ERC20Mock.new(DATA.name, DATA.symbol, DATA.decimals);
            
            assert.equal(await erc20.decimals(), DATA.decimals);            
        });
    });

    describe("mint(address, uint256)", () => {
        it("should mint", async () => {
            const erc20 = await ERC20Mock.new(DATA.name, DATA.symbol, DATA.decimals);
            
            await erc20.mint(SECOND, DATA.mint);

            assert.equal(await erc20.balanceOf(SECOND), DATA.mint);
        });
    });

    describe("burn(uint256)", () => {
        it("should burn", async () => {
            const erc20 = await ERC20Mock.new(DATA.name, DATA.symbol, DATA.decimals);
            
            await erc20.mint(SECOND, DATA.mint);

            // DATA.mint is 100, so 100 - 50 = 50.
            await erc20.burn(SECOND, "50")
            assert.equal(await erc20.balanceOf(SECOND), "50");
        });
    });

});

