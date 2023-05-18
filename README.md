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

### Capture the Ether Predict the block hash

Call settle after 256 blocks, so the block.blockhash will return 0.

### Ethernaut #5 Token

Underflow

### Capture the Ether Token Whale Challenge

It doesn't use `from` correctly and meeses up the balances.

### Capture the Ether Token Sale

Overflow

### Ethernaut #7 Force

Send ether to the contract by calling `selfdestroy` of another contract and giving the address of the ethernaut's contract.

### Capture the Ether Retirement fund

don't wait for the expiration, just add more ether to the fund contract with calling `selfdestruct` of another contract and withdraw all the ether from the fund contract by manipulating it.

### Damn Vulnerable Defi #4 Side Entrance

Make a flashloan and deposit the loan while the flash loan is not returned. The contract thinks you have deposited your own funds.

### Damn Vulnerable Defi #1 Unstoppable

Mess up with the `UnstoppableVault` contract by updating its token balance directly by sending tokens to the token contract for the vault address, so when trying to take a flash loan we get `InvalidBalance` error.

## Week 7

### RareSkills Riddles: Forwarder

We trick the forwarder contract to send us the ether from the wallet contract.

### RareSkills Riddles: Assign Votes

We just use multiple contracts to vote for us.

### Ethernaut #15 Naught Coin

The issue here is not all of the `transfer` functions are locked. We can call `transferFrom` and transfer tokens.

### Damn Vulnerable Defi #3 Truster

The issue here is the `pool` can call any function picked by us as a callback on flash loan. We can call `approve` and approve the pool to spend their tokens and then call `transferFrom` to transfer tokens to attacker.

### RareSkills Riddles: Overmint3

We use helper attacker contracts to mint more tokens for us than possible with a single account.

### RareSkills Riddles: Democracy

We use helper attacker contracts to vote for us.

### RareSkills Riddles: Delete user

The issue here is that `user = users[users.length - 1];` is not updating anything and because of that the users collection is with wrong data in it after the first withdraw and we can hack the contract by depositing money in a specific order.

## Week 8

### RareSkills Riddles: Viceroy

Once we have a proposal and voters we depose the viceroy, then appoint the same viceroy again, set new voters and in the end we have 10 votes in total and an executed proposal.

### Ethernaut #9 King

We istantiate the King contract with the address of the attack contract which doesn't accept ether and when the new king send some ether to the contract the function reverts because the previous king doesn't accept ether and can't receive the prize.

### Ethernaut #20 Denial

We set the withdraw partner to be a contract which has a fallback function which consumes all the gas and then the withdraw function reverts with Out of gas error.

### Ethernaut #23 Dex2

We create temporarly another 2 token which we use in the swap, and because the swap function doesn't check the token address we can swap any token with any other token.

### Ethernaut #17 Recovery

We call `destroy` which calls `selfdestruct` in order to recover the ether.

### Damn Vulnerable DeFi #2 Naive Receiver

We call `flashLoan` 10 times with 0 amount until we drain the contract.

## Week 9

### Ethernaut #8 Vault

We get the password from the storage slot with forge `vm.load` helper function and then call the unlock function with the password.

### RareSkills Riddles: RewardToken

First we deposit the nft, then we wait 10 days and call `withdrawAndClaimEarnings` to get the reward. The function transfer the nft back to us, but in the `onERC721Received` callback we call `claimEarnings` and like that we withdraw reward twice.

### RareSkills Riddles: Simple flash loan

We anipulate the price, first we get flash loan of tokens, then swap them for eth, sfter that we liquidate the borrower's position after the price has been manipulated, we swap back all the eth for tokens and in the end we return the flash loan. At the end we have drained the lending protocol.

### RareSkills Riddles: Read-only reentrancy

We add liquidity, after that we remove the liquidity and while the pool returns the ether and before burns the lpTokens we update the price of the token for the defi protocol and like that the updated price becomes 0.

## Week 10

### Damn Vulnerable DeFi #5

We just wait 5 days for the next round, take flashloan, deposit the loan, withdraw it and we have rewards. The issue is that the contract doesn't check for how long the user had deposit and just sends the rewards.

### Damn Vulnerable DeFi #6

We just take a flash loan and submit a proposal with the flash loaned tokens and then we drain the pool. The issue here is that everybody can call the `snapshot` function of the token.
