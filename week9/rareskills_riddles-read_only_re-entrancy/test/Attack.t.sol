// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/ReadOnly.sol";
import "../src/Attacker.sol";

contract ReadOnlyReEntrancyTest is Test {
    ReadOnlyPool public pool;
    VulnerableDeFiContract public defi;
    Attacker public attacker;
    address player;

    function setUp() public {
        player = vm.addr(1);

        pool = new ReadOnlyPool();
        defi = new VulnerableDeFiContract(pool);

        pool.addLiquidity{value: 100 ether}();
        pool.earnProfit{value: 1 ether}();
        defi.snapshotPrice();

        vm.deal(player, 2 ether);
    }

    function testAttack() public {
        uint256 nonce = vm.getNonce(player);

        vm.startBroadcast(player);

        attacker = new Attacker{value: 2 ether}(pool, defi);
        attacker.attack();

        vm.stopBroadcast();

        assertEq(defi.lpTokenPrice(), 0);
        assertTrue(vm.getNonce(player) - nonce < 3);
    }
}
