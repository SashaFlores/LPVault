// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {CurrencyLibrary, Currency} from "v4-core/src/types/Currency.sol";
import {PoolId} from "v4-core/src/types/PoolId.sol";
import {PoolKey, PoolIdLibrary} from "v4-core/src/types/PoolKey.sol";
import {IHooks} from "v4-core/src/interfaces/IHooks.sol";
import {IPoolManager} from "v4-core/src/interfaces/IPoolManager.sol";
import {IPositionManager} from "v4-periphery/src/interfaces/IPositionManager.sol";
import {SafeCallback} from "v4-periphery/src/base/SafeCallback.sol";
// import {IV4Router} from "v4-periphery/src/interfaces/IV4Router.sol";
import {Actions} from "v4-periphery/src/libraries/Actions.sol";
// import {IPermit2} from "permit2/src/interfaces/IPermit2.sol";
import {IERC20} from "openzeppelin/contracts/token/ERC20/IERC20.sol";
import {StateLibrary} from "v4-core/src/libraries/StateLibrary.sol";



contract MainVault is SafeCallback {
    using CurrencyLibrary for Currency;
    using PoolIdLibrary for PoolKey;
    using StateLibrary for IPoolManager;


    IPoolManager public immutable manager;
    IPositionManager immutable public posm;



    constructor(IPoolManager _manager, IPositionManager _posm) SafeCallback(_manager) {
        manager = _manager;
        posm = _posm;
    }


    /**
     * @notice This function initiates a new pool without funding. 
     * @param currency0 address of the first pair of currency.
     * @param currency1 address of the second pair of currency.
     * @param fee uint24 swapping fee of the pool.
     * @param tickSpacing int256 spacing of the pool.
     * @param startingPrice uint160 initial price of the pool.
     * @param hook address of the hook contract.
     * 
     * @dev V4 requires the currency with the lower address to be currency0,
     * and the currency with the higher address to be currency1.
     * 
     * @dev if `fee` is dynamic, it must be exactly equal to 0x800000.
     * 
     * @dev V4 pools can be hookless, if no customization is needed.
     */
    function createPool(
        address currency0, 
        address currency1, 
        uint24 fee, 
        int24 tickSpacing, 
        uint160 startingPrice, 
        address hook
    ) public virtual returns (bytes32 poolId) {

        if(currency0 > currency1) {
            (currency0, currency1) = (currency1, currency0);
        }

        PoolKey memory key = PoolKey({
            currency0: Currency.wrap(currency0),
            currency1: Currency.wrap(currency1),
            fee: fee,
            tickSpacing: tickSpacing,
            hooks: IHooks(hook) 
        });

        poolId = PoolId.unwrap(key.toId());

        manager.initialize(key, startingPrice);
    }


    /**
     * @notice This function funds an existing pool with native currencies.
     * @param unlockData bytes the data required to unlock the pool.
     * @param deadline uint256 deadline for the transaction.
     * 
     * @dev Excess funding will not be refunded unless `sweep` is encoded in actions.
     * 
     * @dev Provide `deadline` in seconds that will be added to the current block timestamp.
     * 
     * Requirements:
     * - Pool has to be unlocked first from PoolManager, else will revert.
     * - Pool should have clear balances; meaning if PoolManager is owed or owes tokens 
     *   to any addresses, the transaction will revert.
     * 
     * Note:
     * - Pay Extreme Care when encoding parameters in `unlockData` because `modifyLiquidities` is the 
     *   same function used to decrease or remove liquidity from pool, even though the `tokenId` 
     *   of the liquidity provider position is needed.
     */
    function fundPool(bytes calldata unlockData, uint256 deadline) public payable {
        uint256 validTill = block.timestamp + deadline;
        manager.unlock(unlockData);
        posm.modifyLiquidities(unlockData, validTill);
    }

    /**
     * @notice This function creates and funds a pool in a single transaction.
     * @param data bytes array containing the data for creating and funding the pool.
     * 
     * @dev The data encoded is:
     * - `initializePool` function selector and parameters
     * - `modifyLiquidity` function selector and parameters
     */
    function createAndFundPool(bytes[] calldata data) public payable {
        posm.multicall(data);
    }



    function getPoolId(PoolKey calldata key) public pure returns (bytes32 poolId) {
        return PoolId.unwrap(key.toId());
    }



    /**
     * @notice This function retrieves the current state of the pool.
     * @param key PoolKey struct containing the pool's key.
     * @return sqrtPriceX96 The current price encoded as a square root and scaled by 2^96
     * @return tick int24 current tick of the pool.
     * @return protocolFee uint24 the protocol fee of the pool.
     * @return lpFee uint24 the liquidity provider fee of the pool.
     * 
     * - both fees are represented in units of 0.0001%
     */
    function getPoolState(PoolKey calldata key) external view returns (
        uint160 sqrtPriceX96, 
        int24 tick, 
        uint24 protocolFee, 
        uint24 lpFee
    ) {
        return poolManager.getSlot0(key.toId());
    }

    /**
     * @notice This function retrieves the current total liquidity in the pool.
     * @param key PoolKey struct containing the pool's key.
     * @return liquidity uint128 the current liquidity of the pool.
     */
    function getPoolLiquidity(PoolKey calldata key) external view returns (uint128 liquidity) {
        return poolManager.getLiquidity(key.toId());
    }




    function getProviderPosition(
        PoolId poolId, 
        address owner, 
        int24 tickLower, 
        int24 tickUpper, 
        bytes32 salt
    ) external view returns (
        uint128 liquidity, 
        uint256 currency0FeeGrowth, 
        uint256 currency1FeeGrowth
    ) {
        return manager.getPositionInfo(poolId, owner, tickLower, tickUpper, salt);
    }

    function _unlockCallback(bytes calldata data) internal override returns (bytes memory) {
        // (...) = abi.decode(data, (...));
    }
}