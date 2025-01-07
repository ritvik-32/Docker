#!/bin/bash

IPFS_VERSION="v0.18.1"

install_ipfs() {
    if command -v ipfs &> /dev/null
    then
        echo "IPFS is already installed, skipping installation."
    else
        echo "Installing IPFS..."
        wget https://dist.ipfs.tech/go-ipfs/${IPFS_VERSION}/go-ipfs_${IPFS_VERSION}_linux-amd64.tar.gz
        tar -xvzf go-ipfs_${IPFS_VERSION}_linux-amd64.tar.gz
        cd go-ipfs || exit
        sudo bash install.sh
        cd ..
        rm -rf go-ipfs_${IPFS_VERSION}_linux-amd64.tar.gz go-ipfs
        echo "IPFS installed!"
    fi
}

initialize_ipfs() {
    if [ -d "~/.ipfs" ]; then
        echo "IPFS node is already initialized."
    else
        echo "Initializing IPFS node..."
        ipfs init
    fi
}

generate_swarm_key() {
    if [ -f "~/.ipfs/swarm.key" ]; then
        echo "Swarm key already exists, skipping generation."
    else
        echo "Generating swarm key using openssl..."
        mkdir -p ~/.ipfs
        echo "/key/swarm/psk/1.0.0/" > ~/.ipfs/swarm.key
        echo "/base16/" >> ~/.ipfs/swarm.key
        openssl rand -hex 32 >> ~/.ipfs/swarm.key
        echo "Swarm key generated at ~/.ipfs/swarm.key"
    fi
}

configure_ipfs_private_network() {
    echo "Configuring IPFS for private network..."

    # Remove public bootstrap nodes
    ipfs bootstrap rm --all

    ipfs config Addresses.API /ip4/0.0.0.0/tcp/5001
    ipfs config Addresses.Gateway /ip4/0.0.0.0/tcp/8080

    echo "IPFS configured for private network with 0.0.0.0 access!"
}

echo "Setting up local private IPFS node..."

install_ipfs
initialize_ipfs
generate_swarm_key
configure_ipfs_private_network

echo "IPFS setup complete!"


#!/bin/bash

if command -v ipfs &> /dev/null
then
    echo "IPFS is installed."
else
    echo "IPFS is not installed..."
    exit 1
fi

start_ipfs_daemon() {
    echo "Starting IPFS daemon..."
    ipfs daemon
}

start_ipfs_daemon
