// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting {
    struct Candidate {
        string name;
        uint voteCount;
    }

    address public owner;
    mapping(address => bool) public hasVoted;
    Candidate[] public candidates;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    modifier hasNotVoted() {
        require(!hasVoted[msg.sender], "You have already voted");
        _;
    }

    function addCandidate(string memory _name) public onlyOwner{
        candidates.push(Candidate(_name, 0));
    }

    function vote(uint candidateIndex) public hasNotVoted {
        require(candidateIndex < candidates.length, "Invalid candidate index");
        candidates[candidateIndex].voteCount += 1;
        hasVoted[msg.sender] = true;
    }

   
    function getVotes(uint candidateIndex) public view returns (uint) {
        require(candidateIndex < candidates.length, "Invalid candidate index");
        return candidates[candidateIndex].voteCount;
    }

    function getCandidateCount() public view returns (uint) {
        return candidates.length;
    }

    function getCandidate(uint candidateIndex) public view returns (string memory name, uint voteCount) {
        require(candidateIndex < candidates.length, "Invalid candidate index");
        Candidate memory candidate = candidates[candidateIndex];
        return (candidate.name, candidate.voteCount);
    }
}
