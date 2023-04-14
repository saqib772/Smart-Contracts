// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Insurance {
    struct Claim {
        uint256 id;
        uint256 amount;
        address claimant;
        bool verified;
        bool settled;
        uint256 timestamp;
    }

    mapping(uint256 => Claim) private claims;
    mapping(address => bool) private insurers;

    uint256 private claimCounter;

    event ClaimSubmitted(uint256 claimId, uint256 amount, address claimant, uint256 timestamp);
    event ClaimVerified(uint256 claimId, uint256 amount, address claimant, uint256 timestamp);
    event ClaimSettled(uint256 claimId, uint256 amount, address claimant, uint256 timestamp);

    constructor() 
    {
        // Add insurers to the mapping for demo purposes
        insurers[msg.sender] = true;
    }

    modifier onlyInsurer() {
        require(insurers[msg.sender], "You are not a registered insurer");
        _;
    }

    function registerInsurer(address _insurer) public onlyInsurer {
        insurers[_insurer] = true;
    }

    function submitClaim(uint256 _amount) public {
        claimCounter++;
        claims[claimCounter] = Claim(claimCounter, _amount, msg.sender, false, false, block.timestamp);
        emit ClaimSubmitted(claimCounter, _amount, msg.sender, block.timestamp);
    }

    function verifyClaim(uint256 _claimId) public onlyInsurer {
        require(claims[_claimId].id != 0, "Claim does not exist");
        require(!claims[_claimId].verified, "Claim already verified");
        claims[_claimId].verified = true;
        emit ClaimVerified(_claimId, claims[_claimId].amount, claims[_claimId].claimant, block.timestamp);
    }

    function settleClaim(uint256 _claimId) public onlyInsurer {
        require(claims[_claimId].id != 0, "Claim does not exist");
        require(claims[_claimId].verified, "Claim not yet verified");
        require(!claims[_claimId].settled, "Claim already settled");
        claims[_claimId].settled = true;
        payable(claims[_claimId].claimant).transfer(claims[_claimId].amount);
        emit ClaimSettled(_claimId, claims[_claimId].amount, claims[_claimId].claimant, block.timestamp);
    }

    function getClaim(uint256 _claimId) public view returns (uint256, uint256, address, bool, bool, uint256) {
        require(claims[_claimId].id != 0, "Claim does not exist");
        Claim memory claim = claims[_claimId];
        return (claim.id, claim.amount, claim.claimant, claim.verified, claim.settled, claim.timestamp);
    }
}
