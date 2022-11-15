// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;


// variable declaration

contract JamToken{
    //declaration

    string public name = "JAM tOKEN";
    string public symbol = "JAM";
    uint256 public totalSuply = 1000000000000000000000000; // 1 million tokens
    uint8 public decimals = 18;

    // event declaration

    // event declaration for user token transfer
    event Transfer(
        address indexed _from, 
        address indexed _to,
        uint256 _value
    );

    //event for operator approve
    event Approval (
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );


    // data structure
    mapping (address => uint256) public balanceOf;
    mapping(address => mapping(address => uint)) public allowance;
     



    //constructor
    constructor(){
        balanceOf[msg.sender] = totalSuply;
    }



    //tranfer user tokens

    function transfer(address _to, uint256 _value)public returns(bool){
        require(balanceOf[msg.sender] >= _value);
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;

    }



    //approval of an amount to be spent by an operator
    function approve(address _spender, uint256 _value) public returns (bool success){
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
    }






    //token transfer specifying the owner
    function transferFrom(address _from, address _to, uint256 _value) public returns(bool success){
        require(_value <= balanceOf[_from]);
        require(_value <= allowance[_from][msg.sender]);
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;

    }


}