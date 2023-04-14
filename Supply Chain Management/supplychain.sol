// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SupplyChainManagement {
    struct Product {
        uint256 id;
        string name;
        address owner;
        address[] history;
        uint256 timestamp;
    }

    mapping(uint256 => Product) private products;
    mapping(address => bool) private manufacturers;

    uint256 private productCounter;

    event ProductCreated(uint256 productId, string name, address manufacturer);
    event ProductTransferred(uint256 productId, address from, address to, uint256 timestamp);

    constructor() {
        // Add manufacturers to the mapping for demo purposes
        manufacturers[msg.sender] = true;
    }

    modifier onlyManufacturer() {
        require(manufacturers[msg.sender], "You are not a registered manufacturer");
        _;
    }

    function registerManufacturer(address _manufacturer) public onlyManufacturer {
        manufacturers[_manufacturer] = true;
    }

    function createProduct(string memory _name) public onlyManufacturer {
        productCounter++;
        products[productCounter] = Product(productCounter, _name, msg.sender, new address[](0), block.timestamp);
        emit ProductCreated(productCounter, _name, msg.sender);
    }

    function transferProduct(uint256 _productId, address _to) public {
        require(products[_productId].id != 0, "Product does not exist");
        address owner = products[_productId].owner;
        require(owner == msg.sender || manufacturers[msg.sender], "You are not the owner of the product");
        products[_productId].owner = _to;
        products[_productId].history.push(msg.sender);
        products[_productId].timestamp = block.timestamp;
        emit ProductTransferred(_productId, owner, _to, block.timestamp);
    }

    function getProduct(uint256 _productId) public view returns (uint256, string memory, address, address[] memory, uint256) {
        require(products[_productId].id != 0, "Product does not exist");
        Product memory product = products[_productId];
        return (product.id, product.name, product.owner, product.history, product.timestamp);
    }
}
