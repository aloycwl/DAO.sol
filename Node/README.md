 # Node

Contains:

Node.sol - In this node user that have minted the NFT before and got assigned a node is able to create vote.
There are 3 kinds of votes - add game, remove game and withdrawal of the principal token used in the node.
Only games added into the node can allow user to transfer token in or withdraw the tokens from.
Vote creator can cancel the vote anytime as long as the vote is not completed.
Since we only need top 5 NFT holders to vote, anytime there are 3 votes on either for or against,
the vote is completed and the voting action will automatically ensue.
If a game want to enter without voting, the game owner can topup the tokens manually and players
will withdraw directly from his pool instead of the node's pool.
 
Top5.sol - This contract will set the top 5 holder everytime a new NFT is minted, merged or transferred.
It also use to check whether an address belong to top5 and which sub-node the address is belonged to.
If the user has not mint before, it will assign a sub-node for the user and it will be permanent.
 
function createVote(address adr, uint stt) usage:
```
adr - The address of the game owner to be added,
the address of the game owner to be removed,
or the recipient address for bulk withdrawal

stt - The status or index code for the vote.
1 - to add a new game (game owner's address)
2 - to remove an existing game (game owner's address)
3 - bulk withdrawal (recipient's address)
```

Everytime a new voting case is created or any voting action is performed, 
it will emit an event for listening and the code are explained as follows.

event Vote (uint indexed, uint) usage:

```
1st uint parameter (indexed) is the ID of the vote

2nd uint parameter is the voting type

0 - voting canceled
1 - addition of game vote is created
2 - deletion of game vote is created
3 - bulk withdrawal vote is created
4 - a for vote is casted
5 - an against vote is casted
6 - this vote is passed
7 - this vote is failed

```

Set the ERC721 address:
```
bytes32 ptr = 0xa9059cbb00000000000000000000000000000000000000000000000000000000;
bytes32 b32;
assembly {
  b32 := 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
  // Replace this with the ERC721 address
}
Proxy(payable(address(this))).mem(ptr, b32);
```

Set the ERC20 address:
```
bytes32 ptr = 0x2fea05d400000000000000000000000000000000000000000000000000000000;
bytes32 b32;
assembly {
  b32 := 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
  // Replace this with the ERC20 address
}
Proxy(payable(address(this))).mem(ptr, b32);
```

Set the numnber of sub-nodes:
```
bytes32 ptr = 0x00000007616d7420657272000000000000000000000000000000000000000000;
bytes32 b32;
assembly {
  b32 := 10
  // Replace this with the number of desired sub-node
}
Proxy(payable(address(this))).mem(ptr, b32);
``` 
