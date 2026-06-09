// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract VulnerableVault {
    address public owner;

    event Deposited(address indexed sender, uint256 amount);
    event Withdrawn(address indexed recipient, uint256 amount);

    constructor() payable {
        owner = msg.sender;
    }

    receive() external payable {
        emit Deposited(msg.sender, msg.value);
    }

    function deposit() external payable {
        emit Deposited(msg.sender, msg.value);
    }

    function withdrawAll(address payable recipient) external {
        require(msg.sender == owner, "not owner");

        uint256 amount = address(this).balance;
        (bool sent,) = recipient.call{ value: amount }("");
        require(sent, "withdraw failed");

        emit Withdrawn(recipient, amount);
    }
}
