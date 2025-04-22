// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Constants} from "./config/Constants.sol";
import {Script, console} from "forge-std/Script.sol";
import {CurrencyLibrary, Currency} from "v4-core/src/types/Currency.sol";
import {IPoolManager} from "v4-core/src/interfaces/IPoolManager.sol";
import {PoolKey} from "v4-core/src/types/PoolKey.sol";

contract CreatePool is Script, Constants {
    using CurrencyLibrary for Currency;

    IPoolManager public poolManager;

    function run() external {

        // address currency0 = USDCAddress;
        // address currency1 = WETHAddress;
        // uint24 fee = 3000;
        // int24 tickSpacing = 60;
        // uint160 startingPrice = TickMath.getSqrtRatioAtTick(0);

        // PoolKey memory key = PoolKey({
        //     currency0: currency0.toCurrency(),
        //     currency1: currency1.toCurrency(),
        //     fee: fee,
        //     tickSpacing: tickSpacing,
        //     startingPrice: startingPrice
        // });

        // poolManager.createPool(key);
    }
}