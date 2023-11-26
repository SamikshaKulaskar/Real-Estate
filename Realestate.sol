// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

contract LandOwnership {
    struct Land {
        address landowner;
        string place;
        uint price;
        uint uniqueId;
    }

    address public owner;
    uint public landcounter;

    constructor() {
        owner = msg.sender;
        landcounter = 0;
    }

    event Add(address indexed _owner, uint _uniqueId);
    event Transfer(address indexed _from, address indexed _to, uint _landId);

    modifier isOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    mapping(address => Land[]) public _ownedlands;

    function addLand(string memory _place, uint _price) public isOwner {
        landcounter = landcounter + 1;
        Land memory myland = Land({
            landowner: msg.sender,
            place: _place,
            price: _price,
            uniqueId: landcounter
        });
        _ownedlands[msg.sender].push(myland);
        emit Add(msg.sender, landcounter);
    }

    function transferLand(address _landBuyer, uint _uniqueId) public returns (bool) {
        for (uint i = 0; i < _ownedlands[msg.sender].length; i++) {
            if (_ownedlands[msg.sender][i].uniqueId == _uniqueId) {
                Land memory myland = Land({
                    landowner: _landBuyer,
                    place: _ownedlands[msg.sender][i].place,
                    price: _ownedlands[msg.sender][i].price,
                    uniqueId: _uniqueId
                });
                _ownedlands[_landBuyer].push(myland);
                delete _ownedlands[msg.sender][i];
                emit Transfer(msg.sender, _landBuyer, _uniqueId);
            }
        }
        return true;
    }

    function getDetails(address _landowner, uint _index) public view returns (string memory, uint) {
        return (
            _ownedlands[_landowner][_index].place,
            _ownedlands[_landowner][_index].price
        );
    }

    function getNumberOfLands(address _landowner) public view returns (uint) {
        return _ownedlands[_landowner].length;
    }
}
