// SPDX-License-Identifier: MIT
pragma solidity ^0.4.21;

import "./TokenWhaleChallenge.sol";

contract Player {
    TokenWhaleChallenge public token;

    function setToken(address _token) public {
        token = TokenWhaleChallenge(_token);
    }

    function approve() public {
        token.approve(msg.sender, uint256(-1));
    }
}
