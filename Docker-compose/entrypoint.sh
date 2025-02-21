#!/bin/bash
/go/src/github.com/arka-labs/arka-network/build/arkad keys add validator --keyring-backend test
#/go/src/github.com/arka-labs/arka-network/build/arkad keys add delegator --keyring-backend test

delegator_key_output=$( /go/src/github.com/arka-labs/arka-network/build/arkad keys add delegator --keyring-backend test --output json )
echo "Delegator Key Information:" > /go/src/github.com/arka-labs/arka-network/delegator_key_info.txt
echo "$delegator_key_output" >> /go/src/github.com/arka-labs/arka-network/delegator_key_info.txt

/go/src/github.com/arka-labs/arka-network/build/arkad init $MONIKER --chain-id $CHAIN_ID
sed -i "s/stake/uarka/g" ~/.arkaapp/config/genesis.json
/go/src/github.com/arka-labs/arka-network/build/arkad genesis add-genesis-account validator 1000000000000uarka  --keyring-backend test
/go/src/github.com/arka-labs/arka-network/build/arkad genesis add-genesis-account delegator 1000000000000uarka  --keyring-backend test
/go/src/github.com/arka-labs/arka-network/build/arkad genesis gentx validator 90000000000uarka --chain-id $CHAIN_ID --keyring-backend test
/go/src/github.com/arka-labs/arka-network/build/arkad genesis collect-gentxs
sed -i 's/^laddr = "tcp:\/\/127.0.0.1:26657"/laddr = "tcp:\/\/0.0.0.0:26657"/' ~/.arkaapp/config/config.toml
sed -i 's/^address = "localhost:9090"/address = "0.0.0.0:9090"/' ~/.arkaapp/config/app.toml
sed -i 's/^cors_allowed_origins = \[\]/cors_allowed_origins = ["*"]/' ~/.arkaapp/config/config.toml
sed -i 's/^enabled-unsafe-cors = false/enabled-unsafe-cors = true/' ~/.arkaapp/config/app.toml
sed -i '/^\[api\]/,/^\[/ s/^enable = false/enable = true/' ~/.arkaapp/config/app.toml
sed -i 's|^address = "tcp://localhost:1317"|address = "tcp://0.0.0.0:1317"|' ~/.arkaapp/config/app.toml

/go/src/github.com/arka-labs/arka-network/build/arkad start --minimum-gas-prices $MINIMUM_GAS_PRICE

