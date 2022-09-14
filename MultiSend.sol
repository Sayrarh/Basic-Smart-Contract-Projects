//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/// @title  A smart contract that can send ethers to multiple ethereum addresses to optimize gas
contract MultiSend{

   address public owner;

   error ZeroEther(); 
   //error to throw if no ether was passed

   error NotSuccessful();
   //sending ether failed

   error NotOwner();
   //not owner of the contract

   mapping(address => uint) amountLeft; 

   constructor() {
       owner = msg.sender;
   }

   //["0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2", "0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db","0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB"]
   //2000000000000000000

   /// @dev function to deposit funds
   function depositFund() external payable {
    if(msg.value == 0){
        revert ZeroEther();
    } else {
        amountLeft[msg.sender] += msg.value;
    }
   }

   /// @dev function to send ether to multiple accounts
     function sendEther(address[] calldata _whiteListedAddresses, uint amount) external payable{
    
      uint totalamountsend = _whiteListedAddresses.length * amount;

      require(amountLeft[msg.sender] >= totalamountsend);

     for(uint i = 0; i < _whiteListedAddresses.length; i++){
        if(_whiteListedAddresses[i] != address(0)){
          payable(_whiteListedAddresses[i]).transfer(amount);
          amountLeft[msg.sender] -= totalamountsend;
       }else{
           revert NotSuccessful();
       }
    }
    

   }



   /// @dev function to get contract balance
   function contractBal() public view returns(uint){
    return address(this).balance;
   }

   /// @dev function to show each depositors balance
   function showDepositorBal() public view returns(uint bal){
       bal = amountLeft[msg.sender];
   }

   /// @dev function for the owner to withdraw the remaining funds in the contract
   function withdrawBal() public {
    require(address(this).balance > 0, "No funds to withdraw");
    if(owner == msg.sender){
        payable(msg.sender).transfer(address(this).balance);
    }else{
        revert NotOwner();
    }
   }

   receive() external payable{}
}