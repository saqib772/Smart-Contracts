// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
interface IERC721 {
function transferFrom(address _from, address _to, address _tokenId) external;
function approve(address _spender, address _tokenId) external;
function transfer(address _to, address _tokenId) external;
}
contract FanArt {
event Upload(address indexed artist, address indexed artworkId, uint amount);
event Download(address indexed artist, address indexed artworkId, uint amount);
event Approve(address indexed artist, address indexed artworkId, uint amount);
event Revoke(address indexed artist, address indexed artworkId, uint amount);
address public artist;
address public artworkId;
uint public amount;
address public wallet;
mapping(address => bool) public is Approved;
constructor(address _artist, address _artworkId, uint _amount) {
artist = _artist;
artworkId = _artworkId;
amount = _amount;
wallet = msg.sender;
}
function getArtist(uint _id) public view returns (address) {
return address(artworkId).owner();
}
function getArtworkId(uint _id) public view returns (address) {
return artworkId;
}
function getAmount(uint _id) public view returns (uint) {
return amount;
}
function getWallet() public view returns (address) {
return wallet;
}
function upload(uint _id, address _wallet) external {
require(msg.sender == artist, 'Not authorized');
require(_id == getArtworkId(_id),'Artwork Id does not match');
require(wallet == address(this),'Wallet does not match');
_artworkId = _id;
amount = _wallet.balance;
}
function download(uint _id) external {
require(msg.sender == artist, 'Not authorized');
require(_id == getArtworkId(_id),'Artwork Id does not match');
require(wallet == address(this),'Wallet does not match');
_wallet.transfer(amount);
}
function approve(uint _id, address _spender) external {
require(msg.sender == artist, 'Not authorized');
require(_id == getArtworkId(_id),'Artwork Id does not match');
require(_spender == address(wallet),'Spender does not match');
is Approved[artist][_id] = true;
is Approved[artist][_spender] = true;
amount -= _spender.balance;
wallet.transfer(amount);
}
function revoke(uint _id, address _spender) external {
require(msg.sender == artist, 'Not authorized');
require(_id == getArtworkId(_id),'Artwork Id does not match');
require(_spender == address(wallet),'Spender does not match');
is Approved[artist][_id] = false;
is Approved[artist][_spender] = false;
amount += _spender.balance;
wallet.transfer(amount);
}
}
