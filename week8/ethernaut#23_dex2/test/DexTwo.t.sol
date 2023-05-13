// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/DexTwo.sol";

contract DexTwoTest is Test {
    DexTwo public dexTwo;

    function setUp() public {
        dexTwo = new DexTwo();
    }

    function testAttack() public {}
}
