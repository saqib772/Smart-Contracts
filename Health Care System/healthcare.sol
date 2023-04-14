pragma solidity ^0.8.0;

contract HealthSystem {
    struct Patient {
        uint256 patientId;
        string name;
        uint256 age;
        string condition;
    }

    struct Doctor {
        uint256 doctorId;
        string name;
        string specialty;
    }

    mapping(uint256 => Patient) private patients;
    mapping(uint256 => Doctor) private doctors;
    uint256 private doctorCount;
    uint256 private patientCount;

    // Function to add a patient
    function addPatient(uint256 _patientId, string memory _name, uint256 _age, string memory _condition) public {
        require(_patientId > 0, "Patient ID must be greater than zero");
        require(bytes(_name).length > 0, "Name must not be empty");
        require(_age > 0, "Age must be greater than zero");
        require(bytes(_condition).length > 0, "Condition must not be empty");
        require(patients[_patientId].patientId == 0, "Patient ID already exists");

        Patient memory newPatient = Patient(_patientId, _name, _age, _condition);
        patients[_patientId] = newPatient;
        _incrementPatientCount();
    }

    // Function to get patient information
    function getPatient(uint256 _patientId) public view returns (uint256, string memory, uint256, string memory) {
        require(_patientId > 0, "Patient ID must be greater than zero");
        require(patients[_patientId].patientId != 0, "Patient ID does not exist");

        Patient memory patient = patients[_patientId];
        return (patient.patientId, patient.name, patient.age, patient.condition);
    }

    // Function to list doctors
    function listDoctors() public view returns (uint256[] memory) {
        uint256[] memory doctorIds = new uint256[](doctorCount);
        for (uint256 i = 1; i <= doctorCount; i++) {
            doctorIds[i - 1] = i;
        }
        return doctorIds;
    }

    // Function to get doctor information
    function getDoctor(uint256 _doctorId) public view returns (uint256, string memory, string memory) {
        require(_doctorId > 0, "Doctor ID must be greater than zero");
        require(doctors[_doctorId].doctorId != 0, "Doctor ID does not exist");

        Doctor memory doctor = doctors[_doctorId];
        return (doctor.doctorId, doctor.name, doctor.specialty);
    }

    // Function to track patient condition before and after treatment
    function trackPatientCondition(uint256 _patientId, string memory _conditionBefore, string memory _conditionAfter) public {
        require(_patientId > 0, "Patient ID must be greater than zero");
        require(bytes(_conditionBefore).length > 0, "Condition before must not be empty");
        require(bytes(_conditionAfter).length > 0, "Condition after must not be empty");
        require(patients[_patientId].patientId != 0, "Patient ID does not exist");

        Patient storage patient = patients[_patientId];
        patient.condition = _conditionAfter;
    }

    // Internal function to increment doctor count
    function _incrementDoctorCount() internal {
        doctorCount++;
    }

    // Internal function to increment patient count
    function _incrementPatientCount() internal {
        patientCount++;
    }
}
