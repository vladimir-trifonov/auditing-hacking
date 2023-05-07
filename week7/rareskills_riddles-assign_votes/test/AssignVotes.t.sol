// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/AssignVotes.sol";
import "../src/Attacker.sol";

contract AssignVotesTest is Test {
    AssignVotes public assignVotes;
    address attacker;

    function setUp() public {
        address assigner = vm.addr(1);

        assignVotes = new AssignVotes{value: 1 ether}();

        vm.prank(assigner);
        assignVotes.assign(vm.addr(3));
        vm.prank(assigner);
        assignVotes.assign(vm.addr(4));
        vm.prank(assigner);
        assignVotes.assign(vm.addr(5));
        vm.prank(assigner);
        assignVotes.assign(vm.addr(6));
        vm.prank(assigner);
        assignVotes.assign(vm.addr(7));
    }

    function testAttack() public {
        vm.prank(attacker);
        new Attacker(address(assignVotes));

        assertEq(address(assignVotes).balance, 0);
    }
}
