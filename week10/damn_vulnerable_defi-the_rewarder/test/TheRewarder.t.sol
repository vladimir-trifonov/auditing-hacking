// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {AccountingToken} from "../src/AccountingToken.sol";
import {DamnValuableToken} from "../src/DamnValuableToken.sol";
import {FlashLoanerPool} from "../src/FlashLoanerPool.sol";
import {RewardToken} from "../src/RewardToken.sol";
import {TheRewarderPool} from "../src/TheRewarderPool.sol";
import "../src/Attacker.sol";

contract TheRewarderTest is Test {
    uint256 constant TOKENS_IN_LENDER_POOL = 1000000 * 10 ** 18;
    address alice;
    address bob;
    address charlie;
    address david;
    address[] users = new address[](4);
    FlashLoanerPool flashLoanPool;
    TheRewarderPool rewarderPool;
    DamnValuableToken liquidityToken;
    RewardToken rewardToken;
    AccountingToken accountingToken;
    Attacker player;

    function setUp() public {
        vm.warp(1);

        alice = vm.addr(1);
        bob = vm.addr(2);
        charlie = vm.addr(3);
        david = vm.addr(4);
        users[0] = alice;
        users[1] = bob;
        users[2] = charlie;
        users[3] = david;

        liquidityToken = new DamnValuableToken();
        flashLoanPool = new FlashLoanerPool(address(liquidityToken));

        liquidityToken.transfer(address(flashLoanPool), TOKENS_IN_LENDER_POOL);
        rewarderPool = new TheRewarderPool(address(liquidityToken));

        rewardToken = RewardToken(rewarderPool.rewardToken());
        accountingToken = AccountingToken(rewarderPool.accountingToken());

        assertEq(accountingToken.owner(), address(rewarderPool));
        uint256 minterRole = accountingToken.MINTER_ROLE();
        uint256 snapshotRole = accountingToken.SNAPSHOT_ROLE();
        uint256 burnerRole = accountingToken.BURNER_ROLE();

        assertTrue(
            accountingToken.hasAllRoles(
                address(rewarderPool),
                minterRole | snapshotRole | burnerRole
            )
        );
        uint depositAmount = 100 * 10 ** 18;

        for (uint i = 0; i < users.length; i++) {
            liquidityToken.transfer(address(users[i]), depositAmount);
            vm.startBroadcast(users[i]);
            liquidityToken.approve(address(rewarderPool), depositAmount);
            rewarderPool.deposit(depositAmount);
            vm.stopBroadcast();
            assertEq(accountingToken.balanceOf(users[i]), depositAmount);
        }

        assertEq(accountingToken.totalSupply(), depositAmount * users.length);
        assertEq(rewardToken.totalSupply(), 0);

        vm.warp(1 + 5 days);

        uint256 rewardsInRound = rewarderPool.REWARDS();
        for (uint i = 0; i < users.length; i++) {
            vm.prank(users[i]);
            rewarderPool.distributeRewards();
            assertEq(
                rewardToken.balanceOf(users[i]),
                rewardsInRound / users.length
            );
        }

        assertEq(rewardToken.totalSupply(), rewardsInRound);
        assertEq(rewarderPool.roundNumber(), 2);
    }

    function testAttack() public {
        player = new Attacker(address(rewarderPool), address(flashLoanPool));

        assertEq(liquidityToken.balanceOf(address(address(player))), 0);
        vm.warp(1 + 10 days);

        player.attack();

        assertEq(rewarderPool.roundNumber(), 3);

        for (uint i = 0; i < users.length; i++) {
            vm.prank(users[i]);
            rewarderPool.distributeRewards();
            uint userRewards = rewardToken.balanceOf(users[i]);
            uint delta = userRewards - (rewarderPool.REWARDS() / users.length);
            assertLt(delta, 10 ** 16);
        }

        assertGt(rewardToken.totalSupply(), rewarderPool.REWARDS());
        uint playerRewards = rewardToken.balanceOf(address(player));
        assertGt(playerRewards, 0);
        uint delta = rewarderPool.REWARDS() - playerRewards;
        assertLt(delta, 10 ** 17);
        assertEq(liquidityToken.balanceOf(address(player)), 0);
        assertEq(
            liquidityToken.balanceOf(address(flashLoanPool)),
            TOKENS_IN_LENDER_POOL
        );
    }
}
