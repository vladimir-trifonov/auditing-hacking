// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/CollateralToken.sol";
import "../src/FlashLoan.sol";
import "../src/AMM.sol";
import "../src/Lending.sol";
import "../src/Attacker.sol";

contract SimpleFlashLoanTest is Test {
    CollateralToken public token;
    AMM public amm;
    Lending public lending;
    FlashLender public flashLender;
    address lender;
    address borrower;

    function getAMMBytecode(
        address _lendToken
    ) internal pure returns (bytes memory) {
        bytes memory bytecode = type(AMM).creationCode;
        return abi.encodePacked(bytecode, abi.encode(_lendToken));
    }

    function getAMMAddress(uint salt) internal view returns (address) {
        bytes32 hash = keccak256(
            abi.encodePacked(
                bytes1(0xff),
                address(this),
                salt,
                keccak256(getAMMBytecode(address(token)))
            )
        );
        return address(uint160(uint256(hash)));
    }

    function setUp() public {
        lender = vm.addr(1);
        borrower = vm.addr(2);
        vm.deal(lender, 20 ether);
        uint salt = 100;
        token = new CollateralToken();
        address ammAddress = getAMMAddress(salt);
        token.approve(ammAddress, type(uint256).max);
        amm = new AMM{value: 20 ether, salt: bytes32(salt)}(address(token));
        lending = new Lending(address(amm));
        address[] memory supportedTokens = new address[](1);
        supportedTokens[0] = address(token);
        flashLender = new FlashLender(supportedTokens, 0);
        token.transfer(address(flashLender), 500 ether);
        vm.deal(address(this), 6 ether);
        (bool ok, ) = payable(address(lending)).call{value: 6 ether}("");
        assertTrue(ok);
        token.transfer(borrower, 500 ether);
        vm.prank(borrower);
        token.approve(address(lending), type(uint256).max);
        vm.prank(borrower);
        lending.borrowEth(6 ether);
    }

    function testAttack() public {
        uint256 nonce = vm.getNonce(lender);

        vm.prank(lender);
        Attacker attacker = new Attacker{value: address(lender).balance}(
            flashLender,
            token,
            amm,
            lending,
            borrower
        );
        vm.prank(lender);
        attacker.attack();

        int difference = int(token.balanceOf(address(lender))) - 240 ether;
        assertGe(difference, -30 ether);
        assertEq(token.balanceOf(address(lending)), 0);
        assertTrue(vm.getNonce(lender) - nonce < 3);
    }
}
