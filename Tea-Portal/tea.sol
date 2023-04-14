// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.17;

import "hardhat/console.sol";

contract TeaPortal {
    uint256 totalTea; //total tea bought by all users

    address payable public owner;
    event NewTea(address sender, uint256 timestamp, string message,string name);

    constructor() payable {
        console.log("We have been constructed Tea on Blockchain!");
        owner = payable(msg.sender);
        
    }

    struct Tea{
        address giver;   //address of the person who sent the tea   
        string message; //message that the person sent with the tea
        string name; //name of the person who sent the tea
        uint256 timestamp; //time when the tea was sent
    }

    Tea[]  teas;

    function getallTea() public view returns (Tea[] memory) {
        return teas;
    }
    //get all tea bought by a user
    function getTotalTea() public view returns (uint256) {
        console.log("We have %d total tea", totalTea);
        return totalTea;
    }

    function buytea(string memory _message,string memory _name,uint256 _payamount) public payable {

        uint256 cost =0.01 ether;
        require(_payamount <=cost, "You need to pay the exact amount");

        totalTea += 1;
        console.log("%s has bought tea", msg.sender);
        teas.push(Tea(msg.sender,_message,_name,block.timestamp));

        (bool success, ) = owner.call{value: _payamount}("");

        require(success, "Failed to send Ether");

        emit NewTea(msg.sender, block.timestamp, _message,_name);
        
    
    }
}
