//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

//create a smart contract that is able to receive ethers from 
//other addresses and transfer ethers to other addresses.

contract Ether{
    address owner; //only owner can send ether

    constructor() {
        owner = msg.sender;
    }

    mapping(address => uint) public balances;

    //Recieve ether
    receive() external payable{
        balances[msg.sender] += msg.value;
     }

     //tracking user balance
    function deposit() public payable{
         require(msg.value > 0, "Zero ether not allowed");
         balances[msg.sender] += msg.value;
     }

     //send out ether
    function sendEther(uint amount, address recipient) external payable {
        require(msg.sender != address(0), "Not a valid address");
        require(msg.sender == owner, "Not owner");
        require(amount <= address(this).balance, "Ether not sufficient");
        balances[msg.sender] -= amount;
        payable(recipient).transfer(amount);
        balances[recipient] += amount;
    }

    //Get contract balnce
    function getContractBal() public view returns(uint bal){
        bal = address(this).balance;
    }

}