// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.1;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

import { Base64 } from "./libraries/Base64.sol";

contract MyEpicNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
	Counters.Counter private _tokenIds;

	string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

	string[] firstWords = ["Strong", "Weak", "Hip", "Extra", "Hungry", "Long", "Short", "Amazing", "Awesome", "Lovely", "Terrifying", "Shocking", "Surprising", "Lame", "Terrific"];
	string[] secondWords = ["Pizza", "Steak", "Cake", "Cookie", "Cheesecake", "IceCream", "Sandwich", "Brisket", "Cheeseburger", "Coke", "Cupcake", "Bread", "PorkBelly", "Potato", "Strawberry"];
	string[] thirdWords = ["Dino", "Cow", "Llama", "Pig", "Chicken", "Sheep", "Goat", "Dog", "Cat", "Bull", "Hippo", "Koala", "Kangaroo", "Donkey", "Horse"];
	
	constructor() ERC721 ("SquareNFT", "SQUARE") {
        console.log("This is my NFT contract. Whoa!");
    }

	function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {
    	uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
    	rand = rand % firstWords.length;
    	return firstWords[rand];
  	}

	function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {
    	uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
    	rand = rand % secondWords.length;
    	return secondWords[rand];
  	}

	function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {
    	uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
    	rand = rand % thirdWords.length;
    	return thirdWords[rand];
  	}

	function random(string memory input) internal pure returns (uint256) {
    	return uint256(keccak256(abi.encodePacked(input)));
  	}
	

	function makeAnEpicNFT() public {
		uint256 newItemId = _tokenIds.current();

		string memory first = pickRandomFirstWord(newItemId);
    	string memory second = pickRandomSecondWord(newItemId);
    	string memory third = pickRandomThirdWord(newItemId);
		string memory combinedWord = string(abi.encodePacked(first, second, third));

		string memory finalSvg = string(abi.encodePacked(baseSvg, first, second, third, "</text></svg>"));

		string memory json = Base64.encode(
        	bytes(
            	string(
                	abi.encodePacked(
                    	'{"name": "',
                    	combinedWord,
                    	'", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
                    	Base64.encode(bytes(finalSvg)),
                    	'"}'
                	)
            	)
        	)
    	);

		string memory finalTokenUri = string(
        	abi.encodePacked("data:application/json;base64,", json)
    	);

    	console.log("\n--------------------");
    	console.log(finalTokenUri);
    	console.log("--------------------\n");

		_safeMint(msg.sender, newItemId);

		_setTokenURI(newItemId, "data:application/json;base64,ewogICAgIm5hbWUiOiAiRXBpY0xvcmRIYW1idXJnZXIiLAogICAgImRlc2NyaXB0aW9uIjogIkFuIE5GVCBmcm9tIHRoZSBoaWdobHkgYWNjbGFpbWVkIHNxdWFyZSBjb2xsZWN0aW9uIiwKICAgICJpbWFnZSI6ICJkYXRhOmltYWdlL3N2Zyt4bWw7YmFzZTY0LFBITjJaeUI0Yld4dWN6MGlhSFIwY0RvdkwzZDNkeTUzTXk1dmNtY3ZNakF3TUM5emRtY2lJSEJ5WlhObGNuWmxRWE53WldOMFVtRjBhVzg5SW5oTmFXNVpUV2x1SUcxbFpYUWlJSFpwWlhkQ2IzZzlJakFnTUNBek5UQWdNelV3SWo0S0lDQWdJRHh6ZEhsc1pUNHVZbUZ6WlNCN0lHWnBiR3c2SUhkb2FYUmxPeUJtYjI1MExXWmhiV2xzZVRvZ2MyVnlhV1k3SUdadmJuUXRjMmw2WlRvZ01UUndlRHNnZlR3dmMzUjViR1UrQ2lBZ0lDQThjbVZqZENCM2FXUjBhRDBpTVRBd0pTSWdhR1ZwWjJoMFBTSXhNREFsSWlCbWFXeHNQU0ppYkdGamF5SWdMejRLSUNBZ0lEeDBaWGgwSUhnOUlqVXdKU0lnZVQwaU5UQWxJaUJqYkdGemN6MGlZbUZ6WlNJZ1pHOXRhVzVoYm5RdFltRnpaV3hwYm1VOUltMXBaR1JzWlNJZ2RHVjRkQzFoYm1Ob2IzSTlJbTFwWkdSc1pTSStSWEJwWTB4dmNtUklZVzFpZFhKblpYSThMM1JsZUhRK0Nqd3ZjM1puUGc9PSIKfQ==");
		
		console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

		_setTokenURI(newItemId, finalTokenUri);

		_tokenIds.increment();
	}
}