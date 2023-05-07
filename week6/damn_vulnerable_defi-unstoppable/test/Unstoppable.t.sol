// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/UnstoppableVault.sol";
import "../src/DamnValuableToken.sol";
import "../src/ReceiverUnstoppable.sol";

contract UnstoppableTest is Test {
    address deployer;
    address player;
    address someUser;
    DamnValuableToken token;
    UnstoppableVault vault;
    ReceiverUnstoppable receiverContract;

    uint256 constant TOKENS_IN_VAULT = 1000000 * (10 ** 18);
    uint256 constant INITIAL_PLAYER_TOKEN_BALANCE = 10 * (10 ** 18);

    function setUp() public {
        deployer = address(this);
        player = vm.addr(1);
        someUser = vm.addr(2);

        token = new DamnValuableToken();
        vault = new UnstoppableVault(token, deployer, deployer);

        // assertEq(vault.asset(), address(token));

        token.approve(address(vault), TOKENS_IN_VAULT);
        vault.deposit(TOKENS_IN_VAULT, address(deployer));

        assertEq(token.balanceOf(address(vault)), TOKENS_IN_VAULT);
        assertEq(vault.totalAssets(), TOKENS_IN_VAULT);
        assertEq(vault.totalSupply(), TOKENS_IN_VAULT);
        assertEq(vault.maxFlashLoan(address(token)), TOKENS_IN_VAULT);
        assertEq(vault.flashFee(address(token), TOKENS_IN_VAULT - 1), 0);
        assertEq(
            vault.flashFee(address(token), TOKENS_IN_VAULT),
            50000 * (10 ** 18)
        );

        token.transfer(player, INITIAL_PLAYER_TOKEN_BALANCE);
        assertEq(token.balanceOf(player), INITIAL_PLAYER_TOKEN_BALANCE);

        vm.prank(someUser);
        receiverContract = new ReceiverUnstoppable(address(vault));
    }

    // Show it's possible for someUser to take out a flash loan
    function testFlashLoan() public {
        vm.prank(someUser);
        receiverContract.executeFlashLoan(100 * (10 ** 18));
    }

    function testRevert_FlashLoan() public {
        // Expect revert
        token.transfer(address(vault), 1);

        vm.expectRevert(UnstoppableVault.InvalidBalance.selector);

        vm.prank(someUser);
        receiverContract.executeFlashLoan(100 * (10 ** 18));
    }
}
