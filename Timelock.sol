//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract TimeLock{
    /// @title A time lock smart contract would be a wallet that would keep your crypto assets locked for a certain amount of time.

    struct User{
        uint amount;
        uint time;
    }

    mapping(address => User) balances; //keep track of each depositor's wallet balance

    /// @dev function to deposit the ether to be kept 
    function depositEther(uint _time) public payable{
        User storage u = balances[msg.sender];
        require(msg.value > 0, "Put some ethers");
        // u.time = (_time * 1 days) + block.timestamp;
        uint newTime = _time + block.timestamp;
        u.time += newTime;//increment the time everytime the user comes to deposit funds
        u.amount += msg.value;
    }

    /// @dev function to withdraw your assets
    function withdraw() public payable{
        //require(block.timestamp >= deadline, "Not yet time");
         User storage u = balances[msg.sender];
         require(block.timestamp >= u.time, "Not yet time");
         u.amount = msg.value;
         u.amount = 0;
         payable(msg.sender).transfer(msg.value);
    }

    receive() external payable{}
}