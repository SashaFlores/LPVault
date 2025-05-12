# Liquidity Provider Vault

This repo provides a hands-on tutorial for integrating Uniswap v4 into any DApp.

It covers pool creation, liquidity management, dynamic fee settings, and hook flag configuration.

Contracts extend Uniswap v4 Core, Periphery, Hooks, and Universal Router modules.

Three vault versions (TestVault, MainVault, AnvilVault) demonstrate deployment across environments.
Aimed at technical developers building with Uniswap v4 primitives.


## High Level Overview of Uniswap V4 Contracts:


### 1- `PoolManager` Contract:

Acts as the central contract managing all liquidity pools. It handles pool creation, swaps, and liquidity management within a singleton architecture, enhancing efficiency and reducing gas costs. 

### 2- `PositionManager` Contract

Manages liquidity positions using a command-based interface. It allows batching multiple operations (like minting and settling positions) into a single transaction, streamlining liquidity management.

### 3- `PositionDescriptor` Contract

Generates metadata and visual representations for liquidity positions. It aids in displaying position details in user interfaces, especially when positions are represented as NFTs.

### 4- `StateView` Contract

A read-only contract that wraps around the StateLibrary. It facilitates off-chain clients in accessing pool states and positions without altering blockchain state. 

### 5- `UniversalRouter` Contract

A versatile router that aggregates trades across various protocols, including Uniswap v4. It enables complex, multi-step transactions involving ETH, ERC20 tokens, and NFTs in a single operation. 

### 6- `Permit2` Contract

A unified system for token approvals, combining signature-based and allowance-based permissions. It streamlines token approval processes, enhancing security and user experience.

### 7- `Quoter` Contract

Provides swap quotes without executing them. It estimates the output or input amounts for swaps, aiding users in understanding potential trade outcomes. 
