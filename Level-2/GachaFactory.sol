// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract GachaTicket is ERC20, Ownable {
    constructor(uint256 amount) ERC20("GachaTicket", "GTK") {
        _mint(msg.sender, amount);
    }
    
    function mint(uint256 amount) external onlyOwner {
        _mint(msg.sender, amount);
    }
}

contract GachaCapsule is ERC721Enumerable, Ownable {
    uint256 tokenId;
    mapping(uint256 => uint256) stars;
    
    constructor() ERC721("GachaponCapsule", "GCAP") {}
    
    function mint(address _minter, uint256 _stars)external onlyOwner {
        tokenId += 1;
        stars[tokenId] = _stars;
        _mint(_minter, tokenId);
    }
    
    function getStars(uint256 _tokenId) external view returns (uint256) {
        return stars[_tokenId];
    }
}

contract GachaMachine {
    using Address for address;
    uint256 private salt;
    uint256 public gachaCost = 1 * 10 ** 18; // 1 ticket
    uint256 public cooldown = 600; // 10 mins
    GachaTicket public gachaTicket;
    GachaCapsule public gachaCapsule;
    
    mapping(address => uint256) nextFreeTicketBlock;
    
    constructor(GachaTicket _gachaTicket, GachaCapsule _gachaCapsule) {
        gachaTicket = _gachaTicket;
        gachaCapsule = _gachaCapsule;
    }
    
    function checkNextFreeTicket(address _address) external view returns (uint256) {
        return nextFreeTicketBlock[_address];
    }
    
    function getFreeTicket() external {
        require(nextFreeTicketBlock[msg.sender] < block.timestamp, "Please wait until nextFreeTicketBlock");
        nextFreeTicketBlock[msg.sender] = block.timestamp + cooldown;
        gachaTicket.mint(gachaCost);
        gachaTicket.transfer(msg.sender, gachaCost);
    }
    
    function roll() external {
        require(!msg.sender.isContract(), "Only EOA");
        gachaTicket.transferFrom(msg.sender, address(this), gachaCost);
        uint256 rand = _random();
        uint256 stars;
        if(rand < 1) { stars = 5; }         // 5* at 1%
        else if(rand < 5) { stars = 4; }    // 4* at 4%
        else if(rand < 15) { stars = 3; }   // 3* at 10%
        else if(rand < 50) { stars = 2; }   // 2* at 35%
        else { stars = 1; }                 // 1* at 50%
        gachaCapsule.mint(msg.sender, stars);
    }
    
    function _random() internal returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.timestamp, block.number, msg.sender, gachaCapsule.totalSupply()))) % 100;
    }
}