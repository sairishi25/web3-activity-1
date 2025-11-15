//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting {
    
    address public owner;
    
    string public candidate1Name;
    string public candidate2Name;

    uint public candidate1Votes;
    uint public candidate2Votes;
    uint public totalVotes;

    mapping(address => bool) public hasVoted;

    bool public votingOpen = false;
    bool public votingEnded = false;

    uint public result = 0; 

    event VoteCast(address indexed voter, uint candidate);
    event VotingClosed(uint result);

    modifier onlyOwner {
        require(msg.sender == owner, "Not contract owner");
        _;
    }

    modifier votingMustBeOpen {
        require(votingOpen, "Voting is not open.");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function startVoting(string memory _candidate1, string memory _candidate2) public onlyOwner {
        require(!votingOpen && !votingEnded, "A vote is already active or has ended.");
        
        candidate1Name = _candidate1;
        candidate2Name = _candidate2;
        
        candidate1Votes = 0;
        candidate2Votes = 0;
        totalVotes = 0;
        result = 0;

        votingOpen = true;
        votingEnded = false;
    }

    function vote(uint _candidateNo) public votingMustBeOpen {
        require(!hasVoted[msg.sender], "You have already voted.");
        require(_candidateNo == 1 || _candidateNo == 2, "Invalid candidate number.");

        if (_candidateNo == 1) {
            candidate1Votes++;
        } else {
            candidate2Votes++;
        }
        
        totalVotes++;
        hasVoted[msg.sender] = true; 

        emit VoteCast(msg.sender, _candidateNo);
    }

    function closeVoting() public onlyOwner votingMustBeOpen {
        votingOpen = false;
        votingEnded = true;
        
        if (candidate1Votes > candidate2Votes) {
            result = 1;
        } else if (candidate2Votes > candidate1Votes) {
            result = 2;
        } else {
            result = 3;
        }

        emit VotingClosed(result);
    }
}