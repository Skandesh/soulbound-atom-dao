/*
************** ATOM DAO **************
- Only selected 255 members have the ability to vote for governace
- Governors will be issued a Soul-bound token, which is non-transferrable NFT's
- Creator of ATOM DAO, issues these NFT's.
- If any misbehavior from any governors, owner can revoke/cancel their membership
- Person who has membership can burn the tokens
- Every 2 years the membership for ATOM DAO will be refreshed and only well-performing members would get another opportunity in the next tenure.

*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts@4.7.3/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.7.3/access/Ownable.sol";
import "@openzeppelin/contracts@4.7.3/utils/Counters.sol";

contract ATOMDAO is ERC721, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    event Attest(address indexed to, uint8 indexed tokenId);
    event Revoke(address indexed to, uint8 indexed tokenId);

    constructor() ERC721("ATOM DAO", "ATOM") {}

    ///  issues the metadata for the ATOM DAO image 

    function _baseURI() internal pure override returns (string memory) {
        return "https://ipfs.io/ipfs/QmRCKD91mg4XsxvbhMn8V3cUBr92RaSZiFBsm7DimDioa8";
    }

    /// @dev issues the NFT to the members, this is done only by the owner using the onlyOwner modifier
    /// @param to address of the member getting membership from the DAO

    function safeMint(address to) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }

    ///@dev this burns the ownership of the NFT either by the tokenholder or the owner
    ///@param tokenId ID of that particular NFT
    function burn(uint8 tokenId) external  {
        require(ownerOf(tokenId) == msg.sender, "Owner of this token can only burn it!");
        _burn(tokenId);
    }
    ///@dev revokes the membership of DAO if any misconduct or tenure expiration
    function revoke(uint256 tokenId) external onlyOwner {
        _burn(tokenId);
    }


    //Overriding the internal function from the ERC721 to restrict transfer of NFT's to other accounts 
    function _beforeTokenTransfer(address from, address to, uint8 ) pure override internal {
        require(from == address(0) || to == address(0), "This is a special token which can't be transferred");
    } 

    //Overriding the internal function from the ERC721 to restrict transfer of NFT's to other accounts 
    //Emitting the respective events for revoking or giving membership access
    function _afterTransfer(address from, address to, uint8 tokenId)  override internal {
        if (from == address(0)){
            emit Attest( to, tokenId);
        }
        else if (to == address(0)){
            emit Revoke(to, tokenId);
        }
    } 


    
    ///@dev this burns the ownership of the NFT either by the tokenholder or the owner
    ///@param tokenId ID of that particular NFT
    function _burn(uint256 tokenId) internal override(ERC721){
        super._burn(tokenId);
    }
}



