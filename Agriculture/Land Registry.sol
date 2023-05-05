pragma solidity ^0.5.0;

contract LandRegistry {
    struct Land {
        string location;
        uint size;
        address owner;
    }

    // mapping from location to Land struct
    mapping(string => Land) public lands;

    // number of registered lands
    uint land_count;

    // mapping from index to location for easy iteration
    mapping(uint => string) public keys;

    // function to register a new land
    function registerLand(string memory _location, uint _size) public {
        // check if land is already registered
        require(lands[_location].owner == address(0), "Land already registered");

        // create a new Land struct and store it in the mapping
        lands[_location] = Land(_location, _size, msg.sender);

        // add location to keys mapping for easy iteration
        keys[land_count] = _location;

        // increment land count
        land_count++;
    }

    // function to unregister a land
    function unregisterLand(string memory _location) public {
        // check if caller is the owner of the land
        require(lands[_location].owner == msg.sender, "Only the owner can unregister the land");

        // delete the land from the mapping
        delete lands[_location];

        // remove the location from the keys mapping
        for (uint i = 0; i < land_count; i++) {
            if (keccak256(bytes(keys[i])) == keccak256(bytes(_location))) {
                delete keys[i];
                land_count--;
                return;
            }
        }
    }

    // function to transfer ownership of a land
    function transferLand(string memory _location, address _newOwner) public {
        // check if caller is the current owner of the land
        require(lands[_location].owner == msg.sender, "Only the owner can transfer the land");

        // transfer ownership by changing the owner address in the Land struct
        lands[_location].owner = _newOwner;
    }

    // function to get the owner of a land
    function verifyOwnership(string memory _location) public view returns (address) {
        return lands[_location].owner;
    }

    // function to update the size of a land
    function updateLandInformation(string memory _location, uint _newSize) public {
        // check if caller is the owner of the land
        require(lands[_location].owner == msg.sender, "Only the owner can update the land information");

        // update the size in the Land struct
        lands[_location].size = _newSize;
    }

    // function to get the size of a land
    function getLandSize(string memory _location) public view returns (uint) {
        return lands[_location].size;
    }

    // function to check if a land is registered
    function isLandRegistered(string memory _location) public view returns (bool) {
        return lands[_location].owner != address(0);
    }

    // function to get the information of a land
    function getLandInformation(string memory _location) public view returns (string memory, uint, address) {
        return (lands[_location].location, lands[_location].size, lands[_location].owner);
    }

    // function to remove a land from the registry
    function removeLand(string memory _location) public {
        require(lands[_location].owner == msg.sender, "Only the owner can remove the land from the registry");
        delete lands[_location];
    }
function getLandLocation(string memory _location) public view returns (string memory) {
    return lands[_location].location;
}
function getLandCount() public view returns (uint) {
    return land_count;
}


}
