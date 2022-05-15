# Lucky Hacker Level 3

### **Vulnerability**
* Weak randomness: Attacker can predict random number thought global variables

```uint256(keccak256(abi.encodePacked(block.timestamp, block.number, msg.sender, gachaCapsule.totalSupply()))) % 100```

block.timestamp, block.number can be predicted, when attacker call execute attack those value will be the same since it happends in the same transaction

### **Attack**

* Although, `GachaMachine` Lv.3 implement **actual** contract caller prevention 

```require(tx.origin == msg.sender && !msg.sender.isContract(), "Only EOA");```

we still have a change to attack thought the weak randomness vulnerability.

* Create `GachaAttack` contract, which implement the same random function in `GachaMachine`
* Run until get a ramdom number < 1 then call `roll()` by ATTACKER ADDRESS -> have to call in the same block

### **Furthemore**
* Attacker can use this way for attack all of 3 Levels 