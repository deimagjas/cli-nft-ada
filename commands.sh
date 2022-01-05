#!/bin/bash
CHOOSE_NETWORK=${1}
function configure_network () {
        case  "${CHOOSE_NETWORK}" in
        mainnet)
                NETWORK='mainnet'
                VOLUME_IPC='cardano-node-ipc'
		VOLUME_DATA='cardano-node-data'
		VOLUME_KEYS='cardano-nft-keys'
                ;;
        testnet)
                NETWORK='testnet'
                VOLUME_IPC='cardano-testnet-node-ipc'
		VOLUME_DATA='cardano-testnet-node-data'
		VOLUME_KEYS='cardano-testnet-nft-keys'
                ;;
        *)
                NETWORK=''
                ;;
        esac
}
function start_docker_service () {
	sudo systemctl restart docker.service
}
function start_node () {
	local arguments=(
		-e NETWORK="${NETWORK}"
		-v "${VOLUME_IPC}":/ipc 
		-v "${VOLUME_DATA}":/data 
		-v "${VOLUME_KEYS}":/keys
		inputoutput/cardano-node
	)
	docker run "${arguments[@]}" 
}
function main () {
	echo "Iniciando servicio de Docker..."
	start_docker_service
	echo "Iniciando nodo Cardano en ${CHOOSE_NETWORK} ..."
	configure_network
	start_node &
	echo "Mostrando nombre del container"
	docker ps -a
	echo "Exportando CARDANO_NODE_SOCKET_PATH..."
	export CARDANO_NODE_SOCKET_PATH='/ipc/node.socket'
}
echo "Cardano node"
main
