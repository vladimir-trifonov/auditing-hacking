# auditing-hacking

## Week 5

### Ethernaut #3

We just do the same calculations as the contract does.

### Capture the Ether Guess the random number

We can get the block number and the block timeStamp from etherscan.

### Ethernaut #11 Elevator

We can just call the `goTo` function with a number and the return different values from the `isLastFloor` function call.

### Ethernaut #21 Shop

The same as previous we return different price values from the `price` function call of the attack contract.

### Capture the Ether Guess the secret number

We can calculate the n number off chain since the it is uint8 and can have 256 values and then call the `guess` function with the calculated number.

### Capture the Ether Guess the new number

We make the same calculations as the contract does and then call the `guess` function with the calculated number.

### Capture the Ether predict the future

We can call `lockInGuess` with 0 and then can call settle in different blocks until the answer is correct.

### Ethernaut #10 Re-entrancy

We call `withdraw` from the receive callback until we stole all the ether by making a re-entrancy.

### RareSkills Riddles: ERC1155

We call `mint` from the receive callback until we mint 5 nfts by making a re-entrancy.

### Capture the Ether Token Bank

Again, re-entrancy, the `SimpleERC223Token` contract calls `tokenFallback` of the player contract instead of the `TokenBankChallenge` contract and becasue of it the balance is not properly updated.

## Week 6

### Capture the Ether Predict the block hash (this is challenging)

### Ethernaut #5 Token

### Capture the Ether Token Whale Challenge

### Capture the Ether Token Sale (this one is more challenging)

### Ethernaut #7 Force

### Capture the Ether Retirement fund

### Damn Vulnerable Defi #4 Side Entrance

### Damn Vulnerable Defi #1 Unstoppable (this is challenging)

## Week 7

### RareSkills Riddles: Forwarder

### RareSkills Riddles: Assign Votes

### Ethernaut #15 Naught Coin

### Damn Vulnerable Defi #3 Truster (this is challenging)

### RareSkills Riddles: Overmint3

### RareSkills Riddles: Democracy

### RareSkills Riddles: Delete user (this is challenging)

## Week 8

### RareSkills Riddles: Viceroy

Once we have a proposal and voters we depose the viceroy, then appoint the same viceroy again, set new voters and in the end we have 10 votes in total and an executed proposal.

### Ethernaut #9 King

We istantiate the King contract with the address of the attack contract which doesn't accept ether and when the new king send some ether to the contract the function reverts because the previous king doesn't accept ether and can't receive the prize.

### Ethernaut #20 Denial

We set the withdraw partner to be a contract which has a fallback function which consumes all the gas and then the withdraw function reverts with Out of gas error.

### Ethernaut #23 Dex2

### Ethernaut #17

### Damn Vulnerable DeFi #2 Naive Receiver
