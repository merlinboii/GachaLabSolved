# Lucky Hacker Level 2

### **Vulnerability**
* Weak randomness: Attacker can predict random number thought global variables

```uint256(keccak256(abi.encodePacked(block.timestamp, block.number, msg.sender, gachaCapsule.totalSupply()))) % 100```

block.timestamp, block.number can be predicted, when attacker call execute attack those value will be the same since it happends in the same transaction

* Although, `GachaMachine` Lv.2 implement contract caller prevention 

```require(!msg.sender.isContract(), "Only EOA");```

This `isContract()` (from  `Address.sol`) still have a vulnerability since this method relies on extcodesize/address.code.length, which always returns 0 for contracts in `construction`, since the code is only stored at the end of the constructor execution.

### **Attack**
* Create `GachaAttack` contract, which implement attack code in `constructor`
* Inside attack constructor, implement handling error state, which will revert when this contract does not receive Gacha 5 star
* Deploy until get a Gacha 5 star and transfer its ownership to ATTACKER