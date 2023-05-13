// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/King.sol";

contract KingTest is Test {
    King public king;
    address atacker;
    address player;

    function setUp() public {
        atacker = address(this);
        player = vm.addr(1);

        vm.deal(atacker, 10 ether);
        king = new King();
    }

    function testDoS() public {
        vm.deal(atacker, 15 ether);
        (bool success, ) = address(king).call{value: 15 ether}("");
        assertEq(success, false);
    }
}
