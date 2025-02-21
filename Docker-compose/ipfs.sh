#!/bin/bash

# Stop IPFS if running
if pgrep -x "ipfs" > /dev/null; then
    echo "Stopping existing IPFS daemon..."
    ipfs shutdown
    sleep 5
fi

# Define IPFS repo path and swarm key location
export IPFS_PATH="/data/ipfs"
SWARM_KEY_PATH="$IPFS_PATH/swarm.key"

# Initialize IPFS if not already initialized
if [ ! -d "$IPFS_PATH" ] || [ ! -f "$IPFS_PATH/config" ]; then
    echo "Initializing IPFS repo..."
    ipfs init
fi

# Remove old swarm.key if it exists
if [ -f "$SWARM_KEY_PATH" ]; then
    echo "Removing existing swarm.key"
    rm -f "$SWARM_KEY_PATH"
fi

# Generate a valid swarm key without openssl
SWARM_KEY_CONTENT="/key/swarm/psk/1.0.0/
/base16/
$(xxd -p -l 32 /dev/urandom | tr -d '\n')"

# Write swarm key to the file
echo "$SWARM_KEY_CONTENT" > "$SWARM_KEY_PATH"
chmod 600 "$SWARM_KEY_PATH"

# Verify swarm key contents
echo "Generated swarm.key content:"
cat "$SWARM_KEY_PATH"

# Fix IPFS configuration to avoid known issues with private networks
echo "Applying IPFS configuration changes..."
ipfs config --json Routing.Type '"dht"'  
ipfs config --json Swarm.Transports.Network.Websocket false  

# Ensure correct API and Gateway settings
ipfs config Addresses.API "/ip4/0.0.0.0/tcp/5001"
ipfs config Addresses.Gateway "/ip4/0.0.0.0/tcp/8080"

# Fix the Gateway Subdomain Issue (Important)
ipfs config --json Gateway.UseSubdomains false
ipfs config --json Gateway.NoFetch false

# Remove default bootstrap peers and allow manual peering
echo "Removing default bootstrap peers..."
ipfs bootstrap rm --all


# Start IPFS daemon **IN FOREGROUND**
echo "Starting IPFS daemon..."
exec ipfs daemon --enable-pubsub-experiment
