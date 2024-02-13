// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

contract MyToken {
    constructor(){
        owner=msg.sender;
    } 
    //public variables
    string public tName="MX";
    string public tAbbrv="MM";
    uint public totalSupply = 0;
    address public owner;

    //events to maintain the log of the events which happening in our contract
    event Mint(address indexed to, uint amount);
    event Burn(address indexed from, uint amount);
    event Transfer(address indexed from, address indexed to, uint amount);

    //errors
    error InsufficientBalance(uint balance, uint withdrawAmount);

    //mapping variable 
    mapping(address=>uint) public balances;

    //Modifiers: so that we don't have to writer assert again again on each function 
    modifier onlyOwner{ 
        assert(msg.sender == owner);
        _;
    }

    //mint function
    function mint(address _address, uint _value) public onlyOwner{
        totalSupply += _value;
        balances[_address] += _value;  
        emit Mint(_address, _value);
    }

    function burn (address _address, uint _value) public onlyOwner{
        if(balances[_address] < _value){
            revert InsufficientBalance({balance: balances[_address], withdrawAmount: _value});
        }
        else{
            totalSupply -= _value;
            balances[_address] -= _value;
            emit Burn(_address, _value);
        }
    }

    function transfer(address _reciever, uint _value) public{
        require(balances[msg.sender] >= _value , "Account balance must be greater then transfered value!");
        balances[msg.sender] -= _value;
        balances[ _reciever] += _value;
        emit Transfer(msg.sender, _reciever, _value);
    }

}
