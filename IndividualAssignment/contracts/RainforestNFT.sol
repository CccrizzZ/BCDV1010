// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

// interface ERC721 /* is ERC165 */ {
//     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
//     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
//     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
//     function balanceOf(address _owner) external view returns (uint256);
//     function ownerOf(uint256 _tokenId) external view returns (address);
//     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) external payable;
//     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;
//     function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
//     function approve(address _approved, uint256 _tokenId) external payable;
//     function setApprovalForAll(address _operator, bool _approved) external;
//     function getApproved(uint256 _tokenId) external view returns (address);
//     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
// }
// interface ERC165 {
//     function supportsInterface(bytes4 interfaceID) external view returns (bool);
// }

contract RainforestNFT is ERC721{

    // token ids
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // owner address
    address public owner;

    // raribility
    enum rarity {
        NULL,
        COMMON,
        RARE,
        EPIC,
        LEGENDARY
    }

    // 0,1,2,3,4,5 rarity
    uint256 tokenRarity;


    constructor() ERC721("Rainforest", "RFRT") {
        // set owner
        owner = msg.sender;

        // randomize rarity
        generateRarity();

    }

    // only owner can call
    modifier onlyOwner{
        require(msg.sender == owner);
        _;
    }



    // mint function
    function mintNFT(address to) public onlyOwner returns (uint256){
        // increment the token id and mint
        _tokenIds.increment();
        _mint(to, _tokenIds.current());

        // randomly generate rarity
        generateRarity();
        
        return _tokenIds.current();
    }

    // safe transfer function
    function safeTransfer(address from, address to, uint256 tokenId) public {
        safeTransferFrom(from, to, tokenId);
    }
    
    // overload safe transfer function
    function safeTransferData(address from, address to, uint256 tokenId, bytes memory data) public {
        safeTransferFrom(from, to, tokenId, data);
    }








    // generate rarity
    function generateRarity() private returns (uint256){
        uint256 randNum = uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty)))% 101;

        if (randNum <= 50) {
            tokenRarity = uint256(rarity.COMMON);
        }else if (randNum <= 60 && randNum <= 80){
            tokenRarity = uint256(rarity.RARE);
        }else if (randNum <= 90 && randNum <= 95){
            tokenRarity = uint256(rarity.EPIC);
        }else{
            tokenRarity = uint256(rarity.LEGENDARY);
        }

        return(tokenRarity);
    }

    function getRarity() public view returns(uint256){
        return tokenRarity;
    }

}


// NFTs are the digital manifestation of items like movie tickets, 
// in that they can contain information in addition to just the owner, 
// lending them all sorts of uses and unforeseen value. 
// Put simply: 
// you could have a movie ticket for Star Wars whereas I could have a movie ticket for Avengers. 
// These tickets are not equal in properties or value which makes them non-fungible.