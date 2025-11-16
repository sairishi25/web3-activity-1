// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Voting {
        
        struct candidate{
            address cand_address;
            string candidate_name;
            uint candidate_id;
            uint vote_count;
          }
         
        address public owner;
        string public winner_name;

        constructor() {
            owner = msg.sender;
        }
        
        modifier onlyowner () {
            require(msg.sender==owner,"Only owner can perform this action");
            _;
        }
        bool public voting_open = false;
        candidate[] public cands;
        
        function addcandidate (string memory _candidate_name, uint _candidate_id  ) onlyowner public {
            require(voting_open==false,"Voting going on");
            cands.push(candidate(msg.sender,_candidate_name,_candidate_id,0));

        }

        function open_voting() onlyowner public  {
            require(voting_open==false,"Voting already started");
            voting_open=true;
        }

        mapping(address => bool) public Voted;
        // mapping(address => uint) public resdec; 

        function vote( uint index) public {
            require(voting_open == true,"voting is not started yet");
            require(!Voted[msg.sender], " vote already given");     
            require(index < cands.length, "candidate not found");
            
            cands[index].vote_count++;
            Voted[msg.sender] = true;
        }

        function close_voting() onlyowner public{
            require(voting_open==true,"Voting already closed");
            voting_open=false;
        }

        function getTotalCandidates() public view returns(uint) {
        return cands.length;
    }

    function getVotes(uint index) onlyowner public view returns (uint) {
        require(index < cands.length, "Invalid candidate");
        return cands[index].vote_count;
     }   

    function declarewinner() onlyowner public {
        require(voting_open==false,"Voting still going on");
        require(cands.length > 0, "No candidates");

        uint maxVotes = 0;
        uint winnerIndex = 0;

        for (uint i = 0; i < cands.length; i++) {
            if (cands[i].vote_count > maxVotes) {
                maxVotes = cands[i].vote_count;
                winnerIndex = i;
            }
        }

        winner_name = cands[winnerIndex].candidate_name;
    }

    function getWinner() public view returns(string memory) {
        return winner_name;
    }
    }