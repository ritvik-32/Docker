#!/bin/bash
if [ -f "/go/src/github.com/arka-labs/agent-orchestrator/.agent-orchestrator/config.yaml" ]; then
    echo "Config file exists."
else
    echo "Config file does not exist."
fi
# Use the binary directly
/go/src/github.com/arka-labs/agent-orchestrator/agent-orchestrator keys list

# Update the chain-id and RPC in the YAML file
sed -i "s|chain-id: .*|chain-id: \"$CHAIN_ID\"|" "$FILE"
sed -i "s|rpc-addr: .*|rpc-addr: \"$RPC_ADDR\"|" "$FILE"
sed -i "s|grpc-addr: .*|grpc-addr: \"$GRPC_ADDR\"|" "$FILE"
sed -i "s|provider: .*|provider: \"$FILE_SERVER\"|" "$FILE"

SEED="few measure sunny sorry lonely stock idea daughter duck purse slogan leisure kitten stone chunk hawk thrive tennis giant neglect bus spider mom robot"
/go/src/github.com/arka-labs/agent-orchestrator/agent-orchestrator keys restore arka_key "$SEED"

# Start the service using the binary
/go/src/github.com/arka-labs/agent-orchestrator/agent-orchestrator service start
