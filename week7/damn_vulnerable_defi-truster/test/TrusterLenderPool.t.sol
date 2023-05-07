// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/TrusterLenderPool.sol";
import "../src/DamnValuableToken.sol";
import "../src/Attacker.sol";

contract TrusterLenderPoolTest is Test {
    Attacker public attacker;
    TrusterLenderPool public pool;
    DamnValuableToken public token;
    uint balance;

    function setUp() public {
        token = new DamnValuableToken();
        pool = new TrusterLenderPool(token);
        attacker = new Attacker(address(pool), address(token));

        balance = token.balanceOf(address(this));

        token.transfer(address(pool), balance);
    }

    function testAttack() public {
        assertEq(token.balanceOf(address(pool)), balance);
        assertEq(token.balanceOf(address(this)), 0);

        attacker.attack(balance);
        attacker.withdraw();

        assertEq(token.balanceOf(address(pool)), 0);
        assertEq(token.balanceOf(address(attacker)), balance);
    }
}
