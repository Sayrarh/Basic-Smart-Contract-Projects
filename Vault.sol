//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Vault{
// a contract where the owner create grant for a beneficiary;
//allows beneficiary to withdraw only when time elapse
//allows owner to withdraw before time elapse
//get information of a beneficiary
//amount of ethers in the smart contract

//Test this contract, write a script for it, and build a factory contract
address owner; //Grant initiator

struct BeneficiaryData{
    uint amountAssigned;
    address beneficiaryAddress;
    uint timeSet;
}

uint ID = 1; //beneficiary ID
uint[] IDs; //array of beneficiaary IDs

BeneficiaryData[] allbeneficiary; //struct of array

mapping(uint => BeneficiaryData) _BeneficiaryData; //mapping of beneficiary ID to their Data

constructor() {
    owner = msg.sender;
}

modifier onlyOwner() {
    require(msg.sender == owner, "Not owner");
    _;
}

modifier timePassed(uint id) { //id here is different
    require(block.timestamp >= _BeneficiaryData[id].timeSet, "Time not reached");
    _;
}

//function to create grant for beneficiaries
function createGrant(address _beneficiaryAddress, uint _time) external payable onlyOwner returns(uint) {
    BeneficiaryData storage BD = _BeneficiaryData[ID];
    require(msg.value > 0, "Zero ether not allowed");
    BD.amountAssigned = msg.value;
    BD.beneficiaryAddress = _beneficiaryAddress;
    BD.timeSet = _time;
    uint id = ID;
    IDs.push(id);
    ID++;
    return id;
}

//function for beneficiary to withdraw grant
function withdrawGrant(uint id) external timePassed(id) { //payable reduces gas
    BeneficiaryData storage BD = _BeneficiaryData[id];
    address user = BD.beneficiaryAddress;
    require(user == msg.sender, "Not part of the beneficiaries");
    require(msg.sender != address(0), "Input a valid address");
    uint amount = BD.amountAssigned;
    BD.amountAssigned = 0; //to avoid reentrancy
    require(amount > 0, "You have no money");
    payable(user).transfer(amount);
}

//function to revert grant before the set time elapses(change of mind)
function RevertGrant(uint id) external timePassed(id) {
     BeneficiaryData storage BD = _BeneficiaryData[id];
     require(BD.amountAssigned > 0, "This beneficiary is broke");
     uint benMoney = BD.amountAssigned;
     payable(owner).transfer(benMoney);
}

//function to withdraw in batches
function withInBatch(uint id, uint amountToWithdraw) external payable timePassed(id) {
    BeneficiaryData storage BD = _BeneficiaryData[id];
    address user = BD.beneficiaryAddress;
    require(user == msg.sender, "Not among beneficiaries");
    require(BD.amountAssigned > 0, "This beneficiary is broke");
    require(amountToWithdraw > 0, "Can't withdraw zero ether");
    BD.amountAssigned -= amountToWithdraw; //amount inputted minus the total amount assigned
    payable(user).transfer(amountToWithdraw);
}

//function to get a beneficiary detail using its ID
function getBeneficiaryDetails(uint id) external view returns(BeneficiaryData memory){
   return _BeneficiaryData[id];
}


//function to return all beneficiaries details
function getAllBeneficiariesDetails() external view returns(BeneficiaryData[] memory BD ){
    uint[] memory allben = IDs; //create a fresh array and assign to the storage
    BD = new BeneficiaryData[](allben.length);
    for(uint i = 0; i<allben.length; i++){
        BD[i] = _BeneficiaryData[allben[i]];
    }
}

//function to return contract Balance
function getContractBalance() public view returns(uint bal){
    bal = address(this).balance;
}
}