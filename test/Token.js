const {expect} = require("chai");
const {ethers} = require("hardhat");

describe("Token contract", function () {
	it("Deployment  should assign  the total supply of tokens to the owner", async function() {
		
		const [ owner ] = await  ethers.getSigners();
		
		const Token = await ethers.getContractFactory("ImageContactNFTAlpha");
		
		const hardhatToken = await Token.deploy();
		
		const ownerBalance = await hardhatToken.balanceOf(owner.address);
		
		console.log('Total Supply: ', await hardhatToken.totalSupply())
		console.log('Owner balance: ', ownerBalance)
		expect(await hardhatToken.totalSupply()).to.equal(ownerBalance);
		done();
		
	});
});
