// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {MockERC20} from "solmate/src/test/utils/mocks/MockERC20.sol";

contract DeployMockERC20 is Script {

    function setUp() public {}


    function run() external {
        vm.startBroadcast();
        MockERC20 token0 = new MockERC20("MockToken0", "MTK0", 18);
        console.log("Token0 Address Is: ", address(token0));

        MockERC20 token1 = new MockERC20("MockToken1", "MTK1", 18);
        console.log("Token1 Address Is: ", address(token1));

        token0.mint(msg.sender, 100_000 ether);
        token1.mint(msg.sender, 100_000 ether);
        console.log("Minter Address Is: ", msg.sender);
        console.log("Token0 Minted: ", token0.balanceOf(msg.sender));
        console.log("Token1 Minted: ", token1.balanceOf(msg.sender));
        console.log("Token0 Decimals: ", token0.decimals());
        console.log("Token1 Decimals: ", token1.decimals());
        vm.stopBroadcast();
    }
}