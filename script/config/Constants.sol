// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {CommonBase} from "forge-std/Base.sol";
import {IHooks} from "v4-core/src/interfaces/IHooks.sol";
import {IPoolManager} from "v4-core/src/interfaces/IPoolManager.sol";
import {PositionManager} from "v4-periphery/src/PositionManager.sol";
import {IAllowanceTransfer} from "permit2/src/interfaces/IAllowanceTransfer.sol";

contract Constants is CommonBase {

    address constant create2Deployer = address(CREATE2_FACTORY);
    
    IPoolManager constant manager = IPoolManager(address(0x5FbDB2315678afecb367f032d93F642f64180aa3));
    PositionManager constant posm = PositionManager(payable(address(0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0)));
    IAllowanceTransfer constant permit2 = IAllowanceTransfer(address(0x000000000022D473030F116dDEE9F6B43aC78BA3));
    IHooks constant hook = IHooks(address(0));
}
