// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {ERC20bigBagBoogie} from "../../src/ERC20bigBagBoogie.sol";
import {DeployBBBtoken} from "../../script/DeployBBBtoken.sol";
import {StdCheats} from "forge-std/StdCheats.sol";

interface MintableToken {
    function mint(address, uint256) external;
}

contract TestERC20bigBagBoogie is Test {
    uint256 BOB_STARTING_AMOUNT = 100 ether;

    ERC20bigBagBoogie public eRC20bigBagBoogie;
    DeployBBBtoken public deployer;
    address public deployerAddress;
    address bob;
    address alice;

    function setUp() public {
        deployer = new DeployBBBtoken();
        eRC20bigBagBoogie = deployer.run();

        bob = makeAddr("bob");
        alice = makeAddr("alice");

        deployerAddress = vm.addr(deployer.deployerKey());
        vm.prank(deployerAddress);
        eRC20bigBagBoogie.transfer(bob, BOB_STARTING_AMOUNT);
    }

    function testInitialSupply() public {
        assertEq(eRC20bigBagBoogie.totalSupply(), deployer.INITIAL_SUPPLY());
    }

    function testUsersCantMint() public {
        vm.expectRevert();
        MintableToken(address(eRC20bigBagBoogie)).mint(address(this), 1);
    }

    function testAllowances() public {
        uint256 initialAllowance = 1000;

        // Alice approves Bob to spend tokens on her behalf
        vm.prank(bob);
        eRC20bigBagBoogie.approve(alice, initialAllowance);
        uint256 transferAmount = 500;

        vm.prank(alice);
        eRC20bigBagBoogie.transferFrom(bob, alice, transferAmount);
        assertEq(eRC20bigBagBoogie.balanceOf(alice), transferAmount);
        assertEq(
            eRC20bigBagBoogie.balanceOf(bob),
            BOB_STARTING_AMOUNT - transferAmount
        );
    }
}
