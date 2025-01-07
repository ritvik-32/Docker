#!/bin/bash
/go/src/github.com/arka-labs/arka-network/build/arkad keys add validator --keyring-backend test
/go/src/github.com/arka-labs/arka-network/build/arkad keys add delegator --keyring-backend test
/go/src/github.com/arka-labs/arka-network/build/arkad init $MONIKER --chain-id $CHAIN_ID
sed -i "s/stake/uarka/g" ~/.arkaapp/config/genesis.json
/go/src/github.com/arka-labs/arka-network/build/arkad genesis add-genesis-account validator 1000000000000uarka  --keyring-backend test
/go/src/github.com/arka-labs/arka-network/build/arkad genesis add-genesis-account delegator 1000000000000uarka  --keyring-backend test
/go/src/github.com/arka-labs/arka-network/build/arkad genesis gentx validator 90000000000uarka --chain-id $CHAIN_ID --keyring-backend test
/go/src/github.com/arka-labs/arka-network/build/arkad genesis collect-gentxs
sed -i 's/^laddr = "tcp:\/\/127.0.0.1:26657"/laddr = "tcp:\/\/0.0.0.0:26657"/' ~/.arkaapp/config/config.toml
/go/src/github.com/arka-labs/arka-network/build/arkad start --minimum-gas-prices $MINIMUM_GAS_PRICE

