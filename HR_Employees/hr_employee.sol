// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract ReferenceCheck
{
IERC20 public immutable token = IERC20(0x5c40ef881cbefe5c2c2aa6d5ec3753e24f2c5a4c2);
uint public constant MIN_TIMESTAMP = 1511288800;
uint public constant MAX_TIMESTAMP = 1538556800;
address payable public employer;
address payable public employee;
uint public employeeId;
uint public startDate;
uint public endDate;

// For example
// startDate = 2017-10-01
// endDate = 2017-10-30

function askForConfirmation(address payable _employer,address payable _employerId,uint _employeeId,uint _startDate,uint _endDate) external
{
employer = payable(msg.sender);
employee = payable(msg.sender);
employeeId = _employeeId;
startDate = _startDate;
endDate = _endDate;
}

// For example
// msg.sender = employee

function check(address payable _employee, uint _employeeId, uint _startDate, uint _endDate) external
{
require(IERC20(token).transferFrom(msg.sender address(this), _employeeId),'');

require(_startDate > MIN_TIMESTAMP, 'start date < min timestamp', '');

require(_endDate < MAX_TIMESTAMP, 'end date > max timestamp', '');

require(_startDate >= _endDate, 'start date < end date', '');

bytes memory data = abi.encode(Employee(employeeId));

require(token.transfer(employer, _employeeId), '');

require(employer.call{value: _employeeId} == _employeeId, '');

(bool confirmed, ) = employee.call{ value: _employeeId}(data,0,_startDate,_endDate);

require(confirmed, 'Failed to Confirm Employment');
}

function onboardNewEmployee(uint _employeeId, uint _startDate, uint _endDate) external 
{
require(IERC20(token).transferFrom(msg.sender address(this), _employeeId),'');

require(_startDate > MIN_TIMESTAMP, 'start date < min timestamp', '');

require(_endDate < MAX_TIMESTAMP, 'end date > max timestamp', '');

require(_startDate >= _endDate, 'start date < end date', '');

bytes memory data = abi.encode({
Employee: Employee(employeeId) SignedMessage: SignedMessage.Create(employer, _employeeId, _startDate, _endDate)}
);

employer.call{
value: _employeeId}
(data, 0, _startDate, _endDate);
}

}

interface Employee
{
address payable owner;
uint id;
uint startDate;
uint endDate;
bytes data;
function getId() external view returns (uint) {
return id;
}

function getOwner() external view returns (address) {
return owner;
}

function getStartDate() external view returns (uint) {
return startDate;
}

function getEndDate() external view returns (uint) {
return endDate;
}

}
