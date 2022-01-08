pragma solidity ^0.6.0;

contract HotelRoom {
    address payable public owner;
    enum Statuses { Vacant, Occupied }
    Statuses currentStatus;
    uint public amount;

    constructor() public{
        owner = msg.sender;
        currentStatus = Statuses.Vacant;
        amount = 2 ether;
    }

    event Occupy(address _occupant, uint _value);

    modifier onlyWhileVacant {
        require(currentStatus == Statuses.Vacant, "Currently Occupied.");
        _;
    }

    modifier costs(uint _amount) {
        require(msg.value >= _amount, "Not Enough Ether Provided.");
        _;
    }


    function updateAmount(uint _amount) public {
        amount = _amount * 1 ether;
    }

    function vacate() public {
        require(msg.sender == owner, "You are not authorized for this action");
        currentStatus = Statuses.Vacant;
    }

    receive() external payable onlyWhileVacant costs(amount) {
        currentStatus = Statuses.Occupied;
        owner.transfer(msg.value);
        emit Occupy(msg.sender, msg.value);
    }
}