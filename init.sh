#!/bin/bash

CHOOSE_NETWORK=${1}
function configure_network () {
        case  "${CHOOSE_NETWORK}" in
        mainnet)
                NETWORK='mainnet'
                VOLUME_IPC='cardano-node-ipc'
                VOLUME_DATA='cardano-node-data'
                VOLUME_KEYS='cardano-nft-keys'
                LOCAL_PATH='/keys'
                ;;
        testnet)
                NETWORK='testnet'
                VOLUME_IPC='cardano-testnet-node-ipc'
                VOLUME_DATA='cardano-testnet-node-data'
                VOLUME_KEYS='cardano-testnet-nft-keys'
                LOCAL_PATH='/keys/testnet'
                ;;
        *)
                NETWORK=''
                ;;
        esac
}
CARDANO_NODE_SOCKET_PATH='/ipc/node.socket'
configure_network
docker run -it --entrypoint cardano-cli \
			-e NETWORK=$NETWORK \
			-e CARDANO_NODE_SOCKET_PATH=$CARDANO_NODE_SOCKET_PATH \
		       	-v "${VOLUME_IPC}":/ipc \
			inputoutput/cardano-node query tip --testnet-magic 1097911063
