// SPDX-License-Identifier: MIT
pragma solidity ^0.4.21;

import "./TokenSaleChallenge.sol";

/// @dev Run the template with
///      ```
///      solc-select use 0.4.25
///      echidna ./TestTokenSaleChallenge.sol --contract TestTokenSaleChallenge --config ./config.yaml
///      ```
contract TestTokenSaleChallenge {
    TokenSaleChallenge token;

    constructor() payable {
        token = new TokenSaleChallenge(this);
        token.send(1 ether);
    }

    function test_buy(uint256 amount) public {
        amount = amount > 0 ? amount : 100000000;

        token.buy.value(amount * 1 ether)(amount);

        assert(!token.isComplete());
    }

    function test_sell(uint256 amount) public {
        uint256 balance = token.balanceOf(this);
        require(balance > 0);
        amount = amount > 0 ? amount : 100000000;
        amount = 1 + (amount % balance);

        token.sell(amount);

        assert(!token.isComplete());
    }

    function() public payable {}
}
