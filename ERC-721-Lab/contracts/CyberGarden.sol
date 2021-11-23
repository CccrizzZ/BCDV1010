// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract CyberGarden is ERC721URIStorage {

    // import counter utility
    using Counters for Counters.Counter;

    // a counter can only increment or decrement by 1
    // here the token id is a counter
    Counters.Counter private _tokenIds;

    constructor() ERC721("CyberGarden", "CYBG") {

    }


    // this function mint a new ERC-721 token an send it to the target account
    function awardItem(address player, string memory tokenURI) public returns (uint256)
    {
        // increment the token id
        _tokenIds.increment();

        // if of the new minted token
        uint256 newItemId = _tokenIds.current();

        // mint that token and send it to target player
        _mint(player, newItemId);

        
        _setTokenURI(newItemId, tokenURI);

        // returns the new token ID
        return newItemId;
    }
}