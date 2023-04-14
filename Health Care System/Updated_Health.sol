// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract HealthSystem is ERC721 {
    struct Patient {
        uint256 id;
        string name;
        string condition;
        bool discharged;
    }

    struct Doctor {
        uint256 id;
        string name;
        address[] patients;
    }

    mapping(uint256 => Patient) private patients;
    mapping(address => Doctor) private doctors;

    uint256 private patientCounter;
    uint256 private doctorCounter;

    event PatientAdded(uint256 patientId, string name, string condition, address doctor);
    event PatientConditionUpdated(uint256 patientId, string condition);
    event PatientDischarged(uint256 patientId);

    constructor() ERC721("HealthSystem", "HS") {}

    function addPatient(string memory _name, string memory _condition) public {
        patientCounter++;
        patients[patientCounter] = Patient(patientCounter, _name, _condition, false);
        _mint(msg.sender, patientCounter);
        emit PatientAdded(patientCounter, _name, _condition, msg.sender);
    }

    function getPatient(uint256 _patientId) public view returns (uint256, string memory, string memory, bool) {
        require(_exists(_patientId), "Patient does not exist");
        Patient memory patient = patients[_patientId];
        return (patient.id, patient.name, patient.condition, patient.discharged);
    }

    function addDoctor(string memory _name) public {
        doctorCounter++;
        doctors[msg.sender] = Doctor(doctorCounter, _name, new address[](0));
    }

    function getDoctor() public view returns (uint256, string memory) {
        Doctor memory doctor = doctors[msg.sender];
        return (doctor.id, doctor.name);
    }

    function getDoctorPatients() public view returns (address[] memory) {
        Doctor memory doctor = doctors[msg.sender];
        return doctor.patients;
    }

    function addPatientToDoctor(address _doctor, uint256 _patientId) public {
        require(_exists(_patientId), "Patient does not exist");
        require(doctors[_doctor].id != 0, "Doctor does not exist");
        require(ownerOf(_patientId) == msg.sender, "You are not the owner of the patient");
        doctors[_doctor].patients.push(msg.sender);
    }

    function updatePatientCondition(uint256 _patientId, string memory _condition) public {
        require(_exists(_patientId), "Patient does not exist");
        require(ownerOf(_patientId) == msg.sender, "You are not the owner of the patient");
        Patient storage patient = patients[_patientId];
        patient.condition = _condition;
        emit PatientConditionUpdated(_patientId, _condition);
    }

    function dischargePatient(uint256 _patientId) public {
        require(_exists(_patientId), "Patient does not exist");
        require(ownerOf(_patientId) == msg.sender, "You are not the owner of the patient");
        Patient storage patient = patients[_patientId];
        patient.discharged = true;
        _burn(_patientId);
        emit PatientDischarged(_patientId);
    }
}
