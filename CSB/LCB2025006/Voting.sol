//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

contract Betting{
    struct bet{
        address payable better;
        uint amount;
        uint team_no;
    }

    bet[] public bets;
    // 0. (0x1093, 1eth, 1)
    // 1. (0x3842, 2eth, 2)

    uint public team1_amount=0;
    uint public team2_amount=0;
    uint public total_bets=0;
    uint public result;

    address public owner;
    uint public min_bet_amount;
    constructor(uint _min_bet_amount){
        owner = msg.sender;
        min_bet_amount = _min_bet_amount;
    }

    modifier onlyOwner{
        require(msg.sender == owner, "Not contract owner");
        _;
    }

    string public team1_name;
    string public team2_name;
    bool public teams_set=false;
    bool public betting_open=false;
    bool public match_ended=false;

    function set_team_names(string memory _team1, string memory _team2) onlyOwner public{
        require(teams_set==false, "team names are already set");
        team1_name = _team1;
        team2_name = _team2;
        teams_set = true;
        betting_open= true;
    }

    function put_bet(uint team_no) public payable {
        require(teams_set==true, "team names not set");
        require(betting_open == true, "Bettings not open");
        require(team_no == 1 || team_no == 2, "Invalid team no");
        require(msg.value >= min_bet_amount, "Increase amount");

        bets.push(bet(payable(msg.sender), msg.value, team_no));

        if(team_no == 1) team1_amount += msg.value;
        else team2_amount += msg.value;

        total_bets++;
    }

    function close_betting() public onlyOwner{
        require(betting_open==true, "Betting already closed!");
        betting_open = false;
    }

    function declare_result(uint winner) public onlyOwner{
        require(betting_open==false, "betting is still open");
        require(winner == 1 || winner == 2, "invalid team no.");
        result = winner;
        match_ended = true;
    }

    function distribute_amount() public onlyOwner payable {
        require(match_ended == true, "match is still running");

        uint winning_team_amount = 0;

        if(result == 1) winning_team_amount = team1_amount;
        else winning_team_amount = team2_amount;

        uint losing_team_amount = 0;

        if(result == 1) losing_team_amount = team2_amount;
        else losing_team_amount = team1_amount; 

        for(uint i = 0; i < total_bets; i++){
            if(bets[i].team_no == result){
                uint ret_amount = ((bets[i].amount * losing_team_amount) / winning_team_amount) + bets[i].amount;
                bets[i].better.transfer(ret_amount);  
            }
        }
    }
}