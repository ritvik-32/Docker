#!/bin/bash

BASE_DIR="/root" 
FILE="$BASE_DIR/.agent-orchestrator/config.yaml"

wait_for_node() {
  echo "Waiting for node to be ready..."
  until curl -s http://localhost:26657/status >/dev/null; do
    echo "Node is not ready yet. Retrying in 5 seconds..."
    sleep 5
  done
  echo "Node is ready!"
}

wait_for_node

CHAIN_ID="arka-devnet-1"
RPC_ADDR="http://159.65.153.201:26657"
GRPC_ADDR="http://159.65.153.201:9090"
KEY_NAME="agent"
IPFS_IP="159.65.153.201"
DOCKER_ENABLE="true"
IPFS_PORT="8081"
HOST_IP="159.65.149.125"
yq eval '.chain.chain-id = "'"$CHAIN_ID"'"' -i "$FILE"
yq eval '.chain.rpc-addr = "'"$RPC_ADDR"'"' -i "$FILE"
yq eval '.chain.grpc-addr = "'"$GRPC_ADDR"'"' -i "$FILE"
yq eval '.chain.key = "'"$KEY_NAME"'"' -i "$FILE"
yq eval '.chain.ipfs-gateway-ip = "'"$IPFS_IP"'"' -i "$FILE"
yq eval '.docker.enable = '"$DOCKER_ENABLE" -i "$FILE"
yq eval ".chain.ipfs-gateway-port = $IPFS_PORT" -i "$FILE"
yq eval '.provider.host-ip = "'"$HOST_IP"'"' -i "$FILE"
"/root/go/bin/agent-orchestrator" keys add $KEY_NAME
sleep 3
"/root/go/bin/agent-orchestrator" service start


