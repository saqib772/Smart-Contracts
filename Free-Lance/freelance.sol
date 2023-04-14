// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FreelancePlatform {
    struct Freelancer {
        address account;
        uint256 ratePerHour;
        bool isRegistered;
    }

    struct Job {
        address client;
        address freelancer;
        uint256 totalAmount;
        uint256 hoursWorked;
        bool isCompleted;
        bool isPaid;
    }

    mapping(address => Freelancer) private freelancers;
    mapping(address => Job[]) private jobs;

    event FreelancerRegistered(address freelancer, uint256 ratePerHour);
    event JobCreated(address client, address freelancer, uint256 totalAmount);
    event JobCompleted(address client, address freelancer, uint256 totalAmount, uint256 hoursWorked);
    event JobPaid(address client, address freelancer, uint256 totalAmount);

    modifier onlyFreelancer() {
        require(freelancers[msg.sender].isRegistered, "You are not a registered freelancer");
        _;
    }

    function registerFreelancer(uint256 _ratePerHour) public {
        require(!freelancers[msg.sender].isRegistered, "You are already a registered freelancer");
        freelancers[msg.sender] = Freelancer(msg.sender, _ratePerHour, true);
        emit FreelancerRegistered(msg.sender, _ratePerHour);
    }

    function createJob(address _freelancer, uint256 _hours) public payable {
        require(freelancers[_freelancer].isRegistered, "Freelancer is not registered");
        require(msg.value > 0, "Job total amount must be greater than 0");
        uint256 totalAmount = freelancers[_freelancer].ratePerHour * _hours;
        require(msg.value == totalAmount, "Sent amount does not match total amount");
        jobs[msg.sender].push(Job(msg.sender, _freelancer, totalAmount, 0, false, false));
        emit JobCreated(msg.sender, _freelancer, totalAmount);
    }

    function completeJob(address _client, uint256 _jobIndex, uint256 _hoursWorked) public onlyFreelancer {
        require(jobs[_client][_jobIndex].freelancer == msg.sender, "You are not the assigned freelancer");
        require(!jobs[_client][_jobIndex].isCompleted, "Job is already completed");
        jobs[_client][_jobIndex].hoursWorked = _hoursWorked;
        jobs[_client][_jobIndex].isCompleted = true;
        emit JobCompleted(_client, msg.sender, jobs[_client][_jobIndex].totalAmount, _hoursWorked);
    }

    function payJob(address _freelancer, uint256 _jobIndex) public payable {
        require(jobs[msg.sender][_jobIndex].client == msg.sender, "You are not the job client");
        require(jobs[msg.sender][_jobIndex].freelancer == _freelancer, "Freelancer does not match the assigned freelancer");
        require(jobs[msg.sender][_jobIndex].isCompleted, "Job is not yet completed");
        require(!jobs[msg.sender][_jobIndex].isPaid, "Job is already paid");
        uint256 totalAmount = jobs[msg.sender][_jobIndex].totalAmount;
        jobs[msg.sender][_jobIndex].isPaid = true;
        payable(_freelancer).transfer(totalAmount);
        emit JobPaid(msg.sender, _freelancer, totalAmount);
    }

        function getFreelancer(address _account) public view returns (address, uint256, bool) {
        Freelancer memory freelancer = freelancers[_account];
        require(freelancer.isRegistered, "Freelancer is not registered");
        return (freelancer.account, freelancer.ratePerHour, freelancer.isRegistered);
    }

    function getJob(address _client, uint256 _jobIndex) public view returns (address, address, uint256, uint256, bool, bool) {
        Job memory job = jobs[_client][_jobIndex];
        require(job.client == _client, "You are not the job client");
        return (job.client, job.freelancer, job.totalAmount, job.hoursWorked, job.isCompleted, job.isPaid);
    }

    function getJobCount(address _client) public view returns (uint256) {
        return jobs[_client].length;
    }

    function getJobPaymentStatus(address _client, uint256 _jobIndex) public view returns (bool) {
        Job memory job = jobs[_client][_jobIndex];
        require(job.client == _client, "You are not the job client");
        return job.isPaid;
    }
}

