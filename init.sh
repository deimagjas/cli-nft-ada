#!/bin/bash

# iniciar docker demon
#sudo systemctl restart docker.service
# iniciar cardano-cli
NETWORK='mainnet'
CARDANO_NODE_SOCKET_PATH='/ipc/node.socket'

docker run -it --entrypoint cardano-cli \
			-e NETWORK=$NETWORK \
			-e CARDANO_NODE_SOCKET_PATH=$CARDANO_NODE_SOCKET_PATH \
		       	-v cardano-node-ipc:/ipc \
			inputoutput/cardano-node query tip --mainnet
