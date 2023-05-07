// SPDX-License-Identifier: MIT
pragma solidity ^0.4.21;

contract Destruct {
    constructor() payable {}

    function destroy(address receiver) {
        assembly {
            selfdestruct(receiver)
        }
    }

    function() public payable {}
}
