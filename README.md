// TODO:

### REAMDE:

- explain what's happening under the hook in the code
- provide links of deployed addresses on different chains
- charts of LP Cycle
- link to SDCC Certificate
- link to Cyfrin Updraft
- link to CodeHawks for first Flights
- link to solodit 

The Differences between mainnet and testnet contracts are:

- No data encoding on mainnet because it consumes gas excessively and almost all of the functions require encoding due to struct usage.
- Data encoding will take place in the backend when deployed on mainnet, some encoding will occur on testnet. 
- contracts structure is a bit different on testnets from mainnets.



### CODE

- Testnet code: exact code as mainnet except using library tests and `PositionManagerTest` smart contract.

- `swap` function on mainnet contract

- Script for mainnet

- test for mainnet