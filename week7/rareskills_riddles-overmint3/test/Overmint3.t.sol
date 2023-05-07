// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Overmint3.sol";
import "../src/Attacker.sol";

contract Overmint3Test is Test {
    Overmint3 public overmint3;

    function setUp() public {
        overmint3 = new Overmint3();
    }

    function testAttack() public {
        Attacker attacker = new Attacker(address(overmint3));

        assertEq(overmint3.totalSupply(), 5);
        assertEq(overmint3.balanceOf(address(attacker)), 5);
    }
}
