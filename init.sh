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
function get_tip () {
	CARDANO_NODE_SOCKET_PATH='/ipc/node.socket'
	local cli_arguments=(
		query tip 
		--testnet-magic 1097911063
	)
	local arguments=(
		-it
		--entrypoint cardano-cli 
		-e NETWORK="${NETWORK}" 
		-e CARDANO_NODE_SOCKET_PATH="${CARDANO_NODE_SOCKET_PATH}" 
		-v "${VOLUME_IPC}":/ipc 
		inputoutput/cardano-node "${cli_arguments[@]}"	
	)
	docker run "${arguments[@]}"
}
echo "Obteniendo tips"
configure_network
get_tip
