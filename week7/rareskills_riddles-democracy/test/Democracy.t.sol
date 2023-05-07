// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Democracy.sol";
import "../src/Attacker.sol";

contract DemocracyTest is Test {
    Democracy public democracy;

    function setUp() public {
        democracy = new Democracy{value: 1 ether}();
    }

    function testAttack() public {
        new Attacker(address(democracy));
        assertEq(address(democracy).balance, 0);
    }
}
