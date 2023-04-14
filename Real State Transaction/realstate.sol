// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract RealEstateTransactions is ERC721 {
    struct Property {
        uint256 id;
        string name;
        address payable seller;
        address payable buyer;
        uint256 price;
        bool rented;
    }

    mapping(uint256 => Property) private properties;
    mapping(address => uint256) private balances;
    mapping(address => bool) private admins;
    mapping(address => uint256) private salesCounts;
    mapping(address => uint256) private purchaseCounts;

    address private owner;
    uint256 private propertyCounter;
    uint256 private topSaleCount;
    uint256 private topPurchaseCount;
    address private topSeller;
    address private topBuyer;

    event PropertyRegistered(uint256 propertyId, string name, address seller, uint256 price);
    event PropertyPurchased(uint256 propertyId, address buyer);
    event PropertyRented(uint256 propertyId, address renter, uint256 price);
    event PropertyTransferred(uint256 propertyId, address from, address to);
    event TopSellerReward(address seller, uint256 rewardCount);
    event TopBuyerReward(address buyer, uint256 rewardCount);

    constructor() ERC721("RealEstateNFT", "REALESTATE") {
        owner = msg.sender;
        admins[msg.sender] = true;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner");
        _;
    }

    modifier onlyAdmin() {
        require(admins[msg.sender], "You are not an admin");
        _;
    }

    function registerAdmin(address _admin) public onlyOwner {
        admins[_admin] = true;
    }

    function unregisterAdmin(address _admin) public onlyOwner {
        require(_admin != owner, "Owner cannot be unregistered as an admin");
        admins[_admin] = false;
    }

    function registerProperty(string memory _name, uint256 _price) public {
        propertyCounter++;
        properties[propertyCounter] = Property(propertyCounter, _name, payable(msg.sender), payable(address(0)), _price, false);
        emit PropertyRegistered(propertyCounter, _name, msg.sender, _price);
    }

    function purchaseProperty(uint256 _propertyId) public payable {
        Property storage property = properties[_propertyId];
        require(property.id != 0, "Property does not exist");
        require(!property.rented, "Property is already rented");
        require(msg.value >= property.price, "Insufficient funds to purchase the property");
        require(property.buyer == address(0), "Property is already sold");
        property.buyer = payable(msg.sender);
        property.seller.transfer(msg.value);
        balances[property.seller] += msg.value;
        salesCounts[property.seller]++;
        purchaseCounts[msg.sender]++;
        emit PropertyPurchased(_propertyId, msg.sender);
        emit PropertyTransferred(_propertyId, property.seller, msg.sender);
        checkTopSeller();
        checkTopBuyer();
    }

    function rentProperty(uint256 _propertyId) public payable {
        Property storage property = properties[_propertyId];
        require(property.id != 0, "Property does not exist");
        require(!property.rented, "Property is already rented");
        require(msg.value >= property.price, "Insufficient funds to rent the property");
        property.seller.transfer(msg.value);
        balances[property.seller] += msg.value;
        property.rented = true;
        emit PropertyRented(_propertyId, msg.sender, property.price);
        emit PropertyTransferred(_propertyId, property.seller, msg.sender);
        checkTopSeller();
        checkTopBuyer();
    }

    function transferProperty(uint256 _propertyId, address _newOwner) public {
        Property storage property = properties[_propertyId];
        require(property.id != 0, "Property does not exist");
        require(property.buyer == msg.sender, "You are not the buyer of the property");
        property.buyer = payable(_newOwner);
        emit PropertyTransferred(_propertyId, msg.sender, _newOwner);
    }

    function checkTopSeller() private {
        if (salesCounts[msg.sender] > topSaleCount) {
            topSaleCount = salesCounts[msg.sender];
            topSeller = msg.sender;
            emit TopSellerReward(msg.sender, topSaleCount);
        }
    }

    function checkTopBuyer() private {
        if (purchaseCounts[msg.sender] > topPurchaseCount) {
            topPurchaseCount = purchaseCounts[msg.sender];
            topBuyer = msg.sender;
            emit TopBuyerReward(msg.sender, topPurchaseCount);
        }
    }

    function getProperty(uint256 _propertyId) public view returns (uint256 id, string memory name, address seller, address buyer, uint256 price, bool rented) {
        Property memory property = properties[_propertyId];
        require(property.id != 0, "Property does not exist");
        return (property.id, property.name, property.seller, property.buyer, property.price, property.rented);
    }

    function getBalance(address _account) public view returns (uint256) {
        return balances[_account];
    }

    function getTopSeller() public view returns (address, uint256) {
        return (topSeller, topSaleCount);
    }

    function getTopBuyer() public view returns (address, uint256) {
        return (topBuyer, topPurchaseCount);
    }

    function mintNFT(address _to, uint256 _tokenId) private {
        _mint(_to, _tokenId);
    }

    function rewardTopSeller() public onlyAdmin {
        require(topSeller != address(0), "Top seller does not exist");
        mintNFT(topSeller, topSaleCount);
    }

    function rewardTopBuyer() public onlyAdmin {
        require(topBuyer != address(0), "Top buyer does not exist");
        mintNFT(topBuyer, topPurchaseCount);
    }

    function withdrawFunds() public {
        uint256 balance = balances[msg.sender];
        require(balance > 0, "No balance to withdraw");
        balances[msg.sender] = 0;
        payable(msg.sender).transfer(balance);
    }

    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function isAdmin(address _account) public view returns (bool) {
        return admins[_account];
    }
}

