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
echo "Iniciando servicio de Docker..."
sudo systemctl restart docker.service
echo "Iniciando nodo Cardano en ${CHOOSE_NETWORK} ..."
configure_network
docker run -e NETWORK="${NETWORK}" -v "${VOLUME_IPC}":/ipc -v "${VOLUME_DATA}":/data -v  "${VOLUME_KEYS}":/keys inputoutput/cardano-node
echo "Mostrando nombre del container"
docker ps -a
echo "Exportando CARDANO_NODE_SOCKET_PATH..."
export CARDANO_NODE_SOCKET_PATH='/ipc/node.socket'
