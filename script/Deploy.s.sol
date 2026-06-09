// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { VulnerableVault } from "../src/VulnerableVault.sol";

interface Vm {
    function startBroadcast() external;
    function stopBroadcast() external;
}

contract Deploy {
    Vm private constant vm = Vm(address(uint160(uint256(keccak256("hevm cheat code")))));

    function run() external returns (VulnerableVault vault) {
        vm.startBroadcast();
        vault = new VulnerableVault();
        vm.stopBroadcast();
    }
}
