// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "../lib/forge-std/src/Script.sol";
import {ERC20bigBagBoogie} from "../src/ERC20bigBagBoogie.sol";
import {console} from "forge-std/console.sol";

contract DeployBBBtoken is Script {
    uint256 public constant INITIAL_SUPPLY = 100_000 ether; // 100.000 tokens with 18 decimal places
    uint256 public DEFAULT_ANVIL_PRIVATE_KEY =
        0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;
    uint256 public deployerKey;

    function run() external returns (ERC20bigBagBoogie) {
        if (block.chainid == 31337) {
            deployerKey = DEFAULT_ANVIL_PRIVATE_KEY;
        } else {
            deployerKey = vm.envUint("PRIVATE_KEY");
        }
        vm.startBroadcast(deployerKey);
        ERC20bigBagBoogie eRC20bigBagBoogie = new ERC20bigBagBoogie(
            INITIAL_SUPPLY
        );
        vm.stopBroadcast;
        return eRC20bigBagBoogie;
    }
}
