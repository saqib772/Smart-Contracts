// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.18;

contract Portfolio {
    struct Project {
        uint id;
        string name;
        string description;
        string image;
        string githubLink;
    }

    struct Education {
        uint id;
        string date;
        string degree;
        string knowledgeAcquired;
        string institutionName;
    }

    struct Experience {
        uint id;
        string date;
        string post;
        string knowledgeAcquired;
        string companyName;
    }

    struct Testimonial {
        uint id;
        string name;
        string feedback;
    }

    struct Award {
        uint id;
        string name;
        string description;
    }

    Project[3] public projects;
    Education[3] public educationDetails;
    Experience[3] public experienceDetails;
    Testimonial[3] public testimonials;
    Award[3] public awards;

    string public imageLink = "Add your CID";
    string public description = "Over 6 months of practical experience with good knowledge in blockchain development. I help the web3 community by contributing in the web3 space.";
    string public resumeLink = "Add your CID";
    uint public projectCount;
    uint public educationCount;
    uint public experienceCount;
    uint public testimonialCount;
    uint public awardCount;
    address public manager;

    mapping(string => string) public socialMediaLinks;
    string public email;
    string public phoneNumber;

    constructor() {
        manager = msg.sender;
    }

    modifier onlyManager() {
        require(manager == msg.sender, "You are not the manager");
        _;
    }

    // Project
    function insertProject(
        string calldata _name,
        string calldata _description,
        string calldata _image,
        string calldata _githubLink
    ) external {
        require(projectCount < 3, "Only 3 projects allowed");
        projects[projectCount] = Project(projectCount, _name, _description, _image, _githubLink);
        projectCount++;
    }

    function changeProject(
        string calldata _name,
        string calldata _description,
        string calldata _image,
        string calldata _githubLink,
        uint _projectCount
    ) external {
        require(_projectCount >= 0 && _projectCount < 3, "Only 3 projects allowed");
        projects[_projectCount] = Project(_projectCount, _name, _description, _image, _githubLink);
    }

    function allProjects() external view returns (Project[3] memory) {
        return projects;
    }

    // Education
    function insertEducation(
        string calldata _date,
        string calldata _degree,
        string calldata _knowledgeAcquired,
        string calldata _institutionName
    ) external onlyManager {
        require(educationCount < 3, "Only 3 education details allowed");
        educationDetails[educationCount] = Education(educationCount, _date, _degree, _knowledgeAcquired, _institutionName);
        educationCount++;
    }

    function changeEducation(
        string calldata _date,
        string calldata _degree,
        string calldata _knowledgeAcquired,
        string calldata _institutionName,
        uint _educationDetailCount
    ) external onlyManager {
        require(_educationDetailCount >= 0 && _educationDetailCount < 3, "Invalid educationCount");
        educationDetails[_educationDetailCount] = Education(_educationDetailCount, _date, _degree, _knowledgeAcquired, _institutionName);
    }

    function allEducationDetails() external view returns (Education[3] memory) {
        return educationDetails;
    }

    // Experience
    function insertExperience(
        string calldata _date,
        string calldata _post,
        string calldata _knowledgeAcquired,
        string calldata _companyName
    ) external onlyManager {
        require(experienceCount < 3, "Only 3 education details allowed");
        experienceDetails[experienceCount] = Experience(experienceCount, _date, _post, _knowledgeAcquired, _companyName);
        experienceCount++;
    }

    function changeExperience(
        string calldata _date,
        string calldata _post,
        string calldata _knowledgeAcquired,
        string calldata _companyName,
        uint _experienceDetailCount
    ) external onlyManager {
        require(_experienceDetailCount >= 0 && _experienceDetailCount < 3, "Invalid experienceCount");
        experienceDetails[_experienceDetailCount] = Experience(_experienceDetailCount, _date, _post, _knowledgeAcquired, _companyName);
    }

    function allExperienceDetails() external view returns (Experience[3] memory) {
        return experienceDetails;
    }

    // Testimonials
    function insertTestimonial(string calldata _name, string calldata _feedback) external {
        require(testimonialCount < 3, "Only 3 testimonials allowed");
        testimonials[testimonialCount] = Testimonial(testimonialCount, _name, _feedback);
        testimonialCount++;
    }

    function changeTestimonial(string calldata _name, string calldata _feedback, uint _testimonialCount) external {
        require(_testimonialCount >= 0 && _testimonialCount < 3, "Invalid testimonialCount");
        testimonials[_testimonialCount] = Testimonial(_testimonialCount, _name, _feedback);
    }

    function allTestimonials() external view returns (Testimonial[3] memory) {
        return testimonials;
    }

    // Awards
    function insertAward(string calldata _name, string calldata _description) external {
        require(awardCount < 3, "Only 3 awards allowed");
        awards[awardCount] = Award(awardCount, _name, _description);
        awardCount++;
    }

    function changeAward(string calldata _name, string calldata _description, uint _awardCount) external {
        require(_awardCount >= 0 && _awardCount < 3, "Invalid awardCount");
        awards[_awardCount] = Award(_awardCount, _name, _description);
    }

    function allAwards() external view returns (Award[3] memory) {
        return awards;
    }

    // Social Media Links
    function setSocialMediaLink(string calldata _platform, string calldata _link) external onlyManager {
        socialMediaLinks[_platform] = _link;
    }

    function getSocialMediaLink(string calldata _platform) external view returns (string memory) {
        return socialMediaLinks[_platform];
    }

    // Contact Information
    function setEmail(string calldata _email) external onlyManager {
        email = _email;
    }

    function setPhoneNumber(string calldata _phoneNumber) external onlyManager {
        phoneNumber = _phoneNumber;
    }

    function changeDescription(string calldata _description) external {
        description = _description;
    }

    function changeResumeLink(string calldata _resumeLink) external onlyManager {
        resumeLink = _resumeLink;
    }

    function changeImageLink(string calldata _imageLink) external onlyManager {
        imageLink = _imageLink;
    }

    function donate() public payable {
        payable(manager).transfer(msg.value);
    }
}
