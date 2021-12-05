// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract OkiContract is ERC721, ERC721Enumerable, Ownable {
	using Strings for uint256;
	string private baseUri;
	string public baseExtension = ".json";
	bool public mintPaused = true;
	bool public onlyWhitelist = true;
	uint256 public constant MAX_SUPPLY = 10000;
	uint256 public constant MAX_PER_TRANSACTION = 10;
	uint256 public constant PRICE = 0.08 ether;
	mapping(address => uint8) whitelist;
	
	constructor() ERC721("OkiContract", "OKI") {}
	
	function mintWhitelist(uint8 numberOfTokens) external payable {
		uint256 totalSupply = totalSupply();
		require(onlyWhitelist, "Whitelist is not active");
		require(numberOfTokens <= whitelist[msg.sender], "Exceeded max available to purchase");
		require(totalSupply + numberOfTokens <= MAX_SUPPLY, "Purchase would exceed max tokens");
		require(PRICE * numberOfTokens <= msg.value, "Ether value sent is not correct");
		whitelist[msg.sender] -= numberOfTokens;
		for (uint256 i = 0; i < numberOfTokens; i++) {
			_safeMint(msg.sender, totalSupply + i);
		}
	}
	
	function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Enumerable) {
		super._beforeTokenTransfer(from, to, tokenId);
	}
	
	function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC721Enumerable) returns (bool) {
		return super.supportsInterface(interfaceId);
	}
	
	function setBaseURI(string memory newBaseURI) external onlyOwner() {
		baseUri = newBaseURI;
	}
	
	function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
		baseExtension = _newBaseExtension;
	}
	
	function _baseURI() internal view virtual override returns (string memory) {
		return baseUri;
	}
	
	function tokenURI(uint256 tokenId) public view override(ERC721) returns (string memory){
		require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
		string memory currentBaseURI = _baseURI();
		return bytes(currentBaseURI).length > 0
		? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
		: "";
	}
	
	function reserve(uint256 n) public onlyOwner {
		uint supply = totalSupply();
		uint i;
		for (i = 0; i < n; i++) {
			_safeMint(msg.sender, supply + i);
		}
	}

	function setPaused(bool newState) public onlyOwner {
		mintPaused = newState;
	}
	
	function setOnlyWhitelist(bool newState) public onlyOwner {
		onlyWhitelist = newState;
	}
	function setWhitelist(address[] calldata addresses, uint8 numAllowedToMint) external onlyOwner {
		for (uint256 i = 0; i < addresses.length; i++) {
			whitelist[addresses[i]] = numAllowedToMint;
		}
	}
	
	function mintOki(uint numberOfTokens) public payable {
		uint256 totalSupply = totalSupply();
		require(!mintPaused, "Contract Paused");
		require(numberOfTokens <= MAX_PER_TRANSACTION, "Exceeded max token purchase");
		require(totalSupply + numberOfTokens <= MAX_SUPPLY, "Purchase would exceed max tokens");
		require(PRICE * numberOfTokens <= msg.value, "Ether value sent is not correct");
		
		for (uint256 i = 0; i < numberOfTokens; i++) {
			_safeMint(msg.sender, totalSupply + i);
		}
	}
	
	function withdraw() public onlyOwner {
		uint balance = address(this).balance;
		payable(msg.sender).transfer(balance);
	}
}
