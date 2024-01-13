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
 

 
create vote - // stt: 1-加游, 2-删游, 3-提币
vote event // 0-取消 1-加游 2-删游 3-提币 4-正票 5-负票 6-通过 7-失败