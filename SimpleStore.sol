//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

//In this contract, take an integer variable and 
//make sure that you are able to read this variable and also update its value. 
//Define two functions one for incrementing the value of the declared variable and 
//the other for decrementing the value.

contract SimpleStore{
     uint public num = 9;

    function incNum(uint _num) public {
        num += 1;
        num = _num; //to update num
    }

    function decNum() public{
        num -= 1;
    }

    function getNum() public view returns(uint){// not necessary since num has been declared public
        return num; //any state variable declared public is a getter function
    }
}