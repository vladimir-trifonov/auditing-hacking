// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/NaiveReceiverLenderPool.sol";
import "../src/Attacker.sol";

contract NaiveReceiverLenderPoolTest is Test {
    NaiveReceiverLenderPool public pool;
    FlashLoanReceiver public receiver;

    address user;
    address player;
    address ETH;

    uint256 constant ETHER_IN_POOL = 1000 * 10 ** 18;
    uint256 constant ETHER_IN_RECEIVER = 10 * 10 ** 18;

    function setUp() public {
        user = vm.addr(1);
        player = vm.addr(2);

        pool = new NaiveReceiverLenderPool();

        ETH = pool.ETH();
        vm.deal(address(this), ETHER_IN_POOL);
        payable(pool).transfer(ETHER_IN_POOL);

        assertEq(address(pool).balance, ETHER_IN_POOL);
        assertEq(pool.maxFlashLoan(ETH), ETHER_IN_POOL);
        assertEq(pool.flashFee(ETH, 0), 10 ** 18);

        receiver = new FlashLoanReceiver(address(pool));

        vm.deal(address(this), ETHER_IN_RECEIVER);
        payable(receiver).transfer(ETHER_IN_RECEIVER);

        assertEq(address(receiver).balance, ETHER_IN_RECEIVER);
    }

    function testRevert_OnFlashLoan() public {
        vm.expectRevert();

        receiver.onFlashLoan(
            address(this),
            ETH,
            ETHER_IN_RECEIVER,
            10 ** 18,
            "0x"
        );
    }

    function testAttack() public {
        Attacker attacker = new Attacker(payable(address(pool)));
        attacker.attack(address(receiver), ETH);

        assertEq(address(receiver).balance, 0);
        assertEq(address(pool).balance, ETHER_IN_POOL + ETHER_IN_RECEIVER);
    }
}
