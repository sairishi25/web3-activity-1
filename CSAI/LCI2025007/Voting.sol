// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract Voting_contract{
    struct Candidate{
        string name;
        uint256 voteCount;
    }
    Candidate[] public candidates;
    mapping(address => bool) public hasVoted;

    constructor (string[] memory _candidate_names){
        for(uint i=0; i< _candidate_names.length; i++){
            addCandidate(_candidate_names[i]);
        }
    }
    function addCandidate(string memory _name) public{
        require(bytes(_name).length > 0 , "Candidate name cannot be empty");
        candidates.push(Candidate(_name, 0));
    }
    function vote(uint _candidate_index) public{
        require( _candidate_index < candidates.length, "Invalid Candidate Index");
        require( hasVoted[msg.sender] == false, "You have already voted");
        hasVoted[msg.sender] == true;
        candidates[_candidate_index].voteCount++;
    }
    function getCandidates_count() public view returns (uint256){
        return candidates.length;
    }
    function getVote_count(uint256 _candidate_index) public view returns (uint256){
        require( _candidate_index < candidates.length, "Invalid Candidate Index");
        return candidates[_candidate_index].voteCount;
    }
}
