// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;


import "./JamToken.sol";
import "./StellarToken.sol";


contract TokenFarm {

    //initial declarations

    string public name = "Stella Token Farm";
    address public owner;
    JamToken public jamToken;
    StellarToken public stellarToken;

    //data structure

    address [] public staker;
    mapping (address => uint) public stakingBalance;
    mapping (address => bool) public hasStaked;
    mapping (address => bool) public isStaking;


    //constuctor

    constructor (StellarToken _stellarToken, JamToken _jamToken) {
    stellarToken = _stellarToken;
    jamToken = _jamToken;     
    owner = msg.sender;

    }

    function stakeTokens (uint _amount) public{
        require(_amount > 0, "la cantidad no pueden ser nuemeros negativos");

        //transfer JAMTokens to principal smart contract

        jamToken.transferFrom(msg.sender, address(this), _amount);
        stakingBalance[msg.sender] += _amount;
        //save staker
        if (!hasStaked[msg.sender]){
            staker.push(msg.sender);
        }
        // update stakins status
        isStaking[msg.sender] = true;
        hasStaked[msg.sender] = true;

    }

    //quit token staking

    function unstakeTokens() public {
        //staking user balance
        uint balance = stakingBalance[msg.sender];

        // require amount > 0
        require(balance > 0, "el balance del staking es 0");
        //transfer of tokens to users
        jamToken.transfer(msg.sender, balance);
        //reset staking balance
        stakingBalance[msg.sender] = 0;
        //update staking status
        isStaking[msg.sender] = false;
    }



    //tokens emit (rewards)
    function issuesTokens() public {
        //only owner
        require(msg.sender == owner, "no eres el owner");

        //token emit for all actually stakers
        for(uint i = 0; i < staker.length; i++){
            address recipient = staker[i];
            uint balance = stakingBalance[recipient];
            if(balance > 0){
                stellarToken.transfer(recipient, balance);
            }
        } 
        }
}

