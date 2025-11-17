// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

contract CandidateContract {
    struct Candidate {
        uint party_no;
        string name;
        uint votes;
    }

    mapping(address => bool) public hasVoted;
    Candidate[] public candidates;

    address public owner;

    

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "you are not the owner");
        _;
    }


    function addingCandidate(uint partyNo, string memory _name) public onlyOwner {
        candidates.push(Candidate(partyNo, _name, 0));
        
    }


    function voting(uint candidateIndex) public {
        require(!hasVoted[msg.sender], "You have already voted");
        require(candidateIndex < candidates.length, "Invalid candidate index");

        hasVoted[msg.sender] = true;

        
        Candidate storage c = candidates[candidateIndex];
        c.votes += 1;

        
    }

    function getTotalCandidates() public view returns (uint) {
        return candidates.length;
    }

    function getCandidate(uint index) public view returns (uint partyNo, string memory name, uint votes) {
        require(index < candidates.length, "invalid candidate index");
        Candidate memory c = candidates[index];
        return (c.party_no, c.name, c.votes);
    }
}


