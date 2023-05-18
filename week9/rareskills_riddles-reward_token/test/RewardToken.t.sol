// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/RewardToken.sol";
import "../src/Attacker.sol";

contract RewardTokenTest is Test {
    Attacker public attacker;
    RewardToken public token;
    NftToStake public nft;
    Depositoor public depositoor;

    address player;

    function setUp() public {
        player = vm.addr(1);

        attacker = new Attacker();
        nft = new NftToStake(address(attacker));
        depositoor = new Depositoor(nft);
        token = new RewardToken(address(depositoor));

        depositoor.setRewardToken(token);
    }

    function testAttack() public {
        attacker.setContracts(nft, depositoor);

        vm.startBroadcast(player);

        vm.warp(1);
        attacker.transfer();
        vm.warp(1 + uint256(10 days));
        attacker.attack();

        vm.stopBroadcast();

        assertEq(token.balanceOf(address(attacker)), 100 ether);
        assertEq(token.balanceOf(address(depositoor)), 0);
    }
}
