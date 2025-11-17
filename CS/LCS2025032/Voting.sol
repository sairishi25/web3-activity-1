//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Vote{
    struct Candidate{
        address letter;
        uint vote_amount;
        uint voter_no;
    }

    Vote[] public votes;

    uint public voter1_votes=0;
    uint public voter2_votes=0;
    uint public voter3_votes=0;
    uint public total_votes=0;
    uint public result;

    address public owner;
    uint public max_votes;
    constructor(uint _max_votes){
        owner = msg.sender;
        max_votes = _max_votes;
    }

    modifier onlyOwner{
        require(msg.sender == owner, "Not Contract Owner");
        _;
    }
    
    string public voter1_name;
    string public voter2_name;
    string public voter3_name;
    bool public voters_set=false;
    bool public voting_open=false;
    bool public voting_ended=false;

    function set_voter_name( string memory _voter1, string memory _voter2, string memory _voter3) onlyOwner public{
        require(voters_set==false, "Voters are already registered");
        voter1_name = _voter1;
        voter2_name = _voter2;
        voter3_name = _voter3;
        voters_set = true;
        voting_open = true;
    }

    function put_vote(uint voters_no)public payable{
        require(voters_set==true, "Voters still not registered");
        require(voting_open==true, "Voting still not available.");
        require(voters_no ==1 || voters_no==2 || voters_no==3, "Invalid voter ID");
        require(msg.value >= max_votes, "Only one vote is allowed");

    if(voters_no==1) voter1_votes += 1;
    else if(voters_no==2) voter2_votes +=2;
    else voter3_votes +=1;

    total_votes++;
    }


    function close_voting() public onlyOwner{
        require(voting_open==true, "Voting already closed!");
        voting_open=false;
    }

    function declare_result(uint winning_candidate) public onlyOwner{
        require(voting_open==false, "Voting is still open");
        require(winning_candidate == 1 || winning_candidate == 2 || winning_candidate == 3, "Invalid candidate");
        result = winning_candidate;
        voting_ended=true;
    }
}
