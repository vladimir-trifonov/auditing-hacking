// SPDX-License-Identifier: MIT
pragma solidity ^0.4.21;

import "./GuessTheSecretNumberChallenge.sol";

contract Attack {
    GuessTheSecretNumberChallenge src;

    // bytes32 answerHash = 0xdb81b4d58595fbbbb592d3661a34cdca14d7ab379441400cbfa1b78bc447c365;
    // function findN() public returns (uint8 n) {
    //     for (uint8 i = 0; i <= 255; i++) {
    //         if (keccak256(i) == answerHash) {
    //             return i;
    //         }
    //     }
    // }

    uint8 n = 170;

    constructor(address _src) {
        src = GuessTheSecretNumberChallenge(_src);
    }

    function attack() public payable {
        src.guess.value(msg.value)(n);
        require(address(this).balance == 2 ether);
    }

    function() payable {}
}
